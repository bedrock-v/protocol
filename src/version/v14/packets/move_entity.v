module packets

import protocol.serializer

pub struct MoveEntityPacket {
pub mut:
	eid i32
	x   f32
	y   f32
	z   f32
}

pub fn (p &MoveEntityPacket) pid() u16 {
	return 0x90
}

pub fn (p &MoveEntityPacket) name() string {
	return 'MoveEntityPacket'
}

pub fn (p &MoveEntityPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &MoveEntityPacket) encode_payload(mut w serializer.Writer) {
	w.be_i32(p.eid)
	w.be_f32(p.x)
	w.be_f32(p.y)
	w.be_f32(p.z)
}

pub fn (mut p MoveEntityPacket) decode_payload(mut r serializer.Reader) ! {
	p.eid = r.be_i32()!
	p.x = r.be_f32()!
	p.y = r.be_f32()!
	p.z = r.be_f32()!
}
