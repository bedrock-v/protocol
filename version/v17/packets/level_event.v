module packets

import protocol.serializer

pub struct LevelEventPacket {
pub mut:
	evid i16
	x    i32
	y    i16
	z    i32
	data i32
}

pub fn (p &LevelEventPacket) pid() u16 {
	return 0x9b
}

pub fn (p &LevelEventPacket) name() string {
	return 'LevelEventPacket'
}

pub fn (p &LevelEventPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &LevelEventPacket) encode_payload(mut w serializer.Writer) {
	w.be_i16(p.evid)
	w.be_i32(p.x)
	w.be_i16(p.y)
	w.be_i32(p.z)
	w.be_i32(p.data)
}

pub fn (mut p LevelEventPacket) decode_payload(mut r serializer.Reader) ! {
	p.evid = r.be_i16()!
	p.x = r.be_i32()!
	p.y = r.be_i16()!
	p.z = r.be_i32()!
	p.data = r.be_i32()!
}
