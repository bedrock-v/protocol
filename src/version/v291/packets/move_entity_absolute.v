module packets

import protocol.serializer
import protocol.version.v291.types

pub struct MoveEntityAbsolutePacket {
pub mut:
	runtime_entity_id u64
	on_ground         bool
	teleported        bool
	force_move        bool
	position          types.Vector3f
	rotation          types.Vector3f
}

pub fn (p &MoveEntityAbsolutePacket) pid() u16 {
	return 18
}

pub fn (p &MoveEntityAbsolutePacket) name() string {
	return 'MoveEntityAbsolutePacket'
}

pub fn (p &MoveEntityAbsolutePacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &MoveEntityAbsolutePacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint64(p.runtime_entity_id)
	mut flags := u8(0)
	if p.on_ground {
		flags |= 0x1
	}
	if p.teleported {
		flags |= 0x2
	}
	if p.force_move {
		flags |= 0x4
	}
	w.u8(flags)
	p.position.encode(mut w)
	types.write_byte_angle(mut w, p.rotation.x)
	types.write_byte_angle(mut w, p.rotation.y)
	types.write_byte_angle(mut w, p.rotation.z)
}

pub fn (mut p MoveEntityAbsolutePacket) decode_payload(mut r serializer.Reader) ! {
	p.runtime_entity_id = r.read_varuint64()!
	flags := r.u8()!
	p.on_ground = flags & 0x1 != 0
	p.teleported = flags & 0x2 != 0
	p.force_move = flags & 0x4 != 0
	p.position = types.Vector3f.decode(mut r)!
	p.rotation = types.Vector3f{
		x: types.read_byte_angle(mut r)!
		y: types.read_byte_angle(mut r)!
		z: types.read_byte_angle(mut r)!
	}
}
