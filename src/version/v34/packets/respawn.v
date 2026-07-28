module packets

import protocol.serializer

pub struct RespawnPacket {
pub mut:
	x f32
	y f32
	z f32
}

pub fn (p &RespawnPacket) pid() u16 {
	return 0xb3
}

pub fn (p &RespawnPacket) name() string {
	return 'RespawnPacket'
}

pub fn (p &RespawnPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &RespawnPacket) encode_payload(mut w serializer.Writer) {
	w.be_f32(p.x)
	w.be_f32(p.y)
	w.be_f32(p.z)
}

pub fn (mut p RespawnPacket) decode_payload(mut r serializer.Reader) ! {
	p.x = r.be_f32()!
	p.y = r.be_f32()!
	p.z = r.be_f32()!
}
