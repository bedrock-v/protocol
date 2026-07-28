module packets

import protocol.serializer

pub struct StartGamePacket {
pub mut:
	seed     i32
	unknown1 i32
	gamemode i32
	eid      i32
	x        f32
	y        f32
	z        f32
}

pub fn (p &StartGamePacket) pid() u16 {
	return 0x87
}

pub fn (p &StartGamePacket) name() string {
	return 'StartGamePacket'
}

pub fn (p &StartGamePacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &StartGamePacket) encode_payload(mut w serializer.Writer) {
	w.be_i32(p.seed)
	w.be_i32(p.unknown1)
	w.be_i32(p.gamemode)
	w.be_i32(p.eid)
	w.be_f32(p.x)
	w.be_f32(p.y)
	w.be_f32(p.z)
}

pub fn (mut p StartGamePacket) decode_payload(mut r serializer.Reader) ! {
	p.seed = r.be_i32()!
	p.unknown1 = r.be_i32()!
	p.gamemode = r.be_i32()!
	p.eid = r.be_i32()!
	p.x = r.be_f32()!
	p.y = r.be_f32()!
	p.z = r.be_f32()!
}
