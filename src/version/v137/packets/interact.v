module packets

import protocol.serializer

pub struct InteractPacket {
pub mut:
	action u8
	target u64
	x      f32
	y      f32
	z      f32
}

pub fn (p &InteractPacket) pid() u16 {
	return 33
}

pub fn (p &InteractPacket) name() string {
	return 'InteractPacket'
}

pub fn (p &InteractPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &InteractPacket) encode_payload(mut w serializer.Writer) {
	w.u8(p.action)
	w.write_varuint64(p.target)
	if p.action == 4 {
		w.le_f32(p.x)
		w.le_f32(p.y)
		w.le_f32(p.z)
	}
}

pub fn (mut p InteractPacket) decode_payload(mut r serializer.Reader) ! {
	p.action = r.u8()!
	p.target = r.read_varuint64()!
	if p.action == 4 {
		p.x = r.le_f32()!
		p.y = r.le_f32()!
		p.z = r.le_f32()!
	}
}
