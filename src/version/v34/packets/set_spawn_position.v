module packets

import protocol.serializer

pub struct SetSpawnPositionPacket {
pub mut:
	x i32
	y i32
	z i32
}

pub fn (p &SetSpawnPositionPacket) pid() u16 {
	return 0xb1
}

pub fn (p &SetSpawnPositionPacket) name() string {
	return 'SetSpawnPositionPacket'
}

pub fn (p &SetSpawnPositionPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &SetSpawnPositionPacket) encode_payload(mut w serializer.Writer) {
	w.be_i32(p.x)
	w.be_i32(p.y)
	w.be_i32(p.z)
}

pub fn (mut p SetSpawnPositionPacket) decode_payload(mut r serializer.Reader) ! {
	p.x = r.be_i32()!
	p.y = r.be_i32()!
	p.z = r.be_i32()!
}
