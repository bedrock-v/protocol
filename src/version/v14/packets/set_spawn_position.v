module packets

import serializer

pub struct SetSpawnPositionPacket {
pub mut:
	x i32
	z i32
	y u8
}

pub fn (p &SetSpawnPositionPacket) pid() u16 {
	return 0xab
}

pub fn (p &SetSpawnPositionPacket) name() string {
	return 'SetSpawnPositionPacket'
}

pub fn (p &SetSpawnPositionPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &SetSpawnPositionPacket) encode_payload(mut w serializer.Writer) {
	w.be_i32(p.x)
	w.be_i32(p.z)
	w.u8(p.y)
}

pub fn (mut p SetSpawnPositionPacket) decode_payload(mut r serializer.Reader) ! {
	p.x = r.be_i32()!
	p.z = r.be_i32()!
	p.y = r.u8()!
}
