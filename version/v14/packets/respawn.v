module packets

import protocol.serializer

pub struct RespawnPacket {
pub mut:
	eid i32
	x   f32
	y   f32
	z   f32
}

pub fn (p &RespawnPacket) pid() u16 {
	return 0xad
}

pub fn (p &RespawnPacket) name() string {
	return 'RespawnPacket'
}

pub fn (p &RespawnPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &RespawnPacket) encode_payload(mut w serializer.Writer) {
	w.be_i32(p.eid)
	w.be_f32(p.x)
	w.be_f32(p.y)
	w.be_f32(p.z)
}

pub fn (mut p RespawnPacket) decode_payload(mut r serializer.Reader) ! {
	p.eid = r.be_i32()!
	p.x = r.be_f32()!
	p.y = r.be_f32()!
	p.z = r.be_f32()!
}
