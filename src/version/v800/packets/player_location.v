module packets

import serializer

pub struct PlayerLocationCoordinates {
pub mut:
	target_entity_id i64
	position         [3]f32
}

pub struct PlayerLocationHide {
pub mut:
	target_entity_id i64
}

pub type PlayerLocationType = PlayerLocationCoordinates | PlayerLocationHide

pub fn (t PlayerLocationType) encode(mut w serializer.Writer) {
	match t {
		PlayerLocationCoordinates {
			w.le_i32(0)
			w.write_varint64(t.target_entity_id)
			w.le_f32(t.position[0])
			w.le_f32(t.position[1])
			w.le_f32(t.position[2])
		}
		PlayerLocationHide {
			w.le_i32(1)
			w.write_varint64(t.target_entity_id)
		}
	}
}

pub fn PlayerLocationType.decode(mut r serializer.Reader) !PlayerLocationType {
	d := r.le_i32()!
	match d {
		0 {
			return PlayerLocationCoordinates{
				target_entity_id: r.read_varint64()!
				position:         [r.le_f32()!, r.le_f32()!, r.le_f32()!]!
			}
		}
		1 {
			return PlayerLocationHide{
				target_entity_id: r.read_varint64()!
			}
		}
		else {
			return error('invalid PlayerLocationType ${d}')
		}
	}
}

pub struct PlayerLocationPacket {
pub mut:
	update PlayerLocationType = PlayerLocationHide{}
}

pub fn (p &PlayerLocationPacket) pid() u16 { return 326 }

pub fn (p &PlayerLocationPacket) name() string { return 'PlayerLocationPacket' }

pub fn (p &PlayerLocationPacket) can_be_sent_before_login() bool { return false }

pub fn (p &PlayerLocationPacket) encode_payload(mut w serializer.Writer) {
	p.update.encode(mut w)
}

pub fn (mut p PlayerLocationPacket) decode_payload(mut r serializer.Reader) ! {
	p.update = PlayerLocationType.decode(mut r)!
}
