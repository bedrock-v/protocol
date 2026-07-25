module packets

import serializer

pub struct SetSpawnPositionPacket {
pub mut:
	spawn_type   i32
	x            i32
	y            u32
	z            i32
	spawn_forced bool
}

pub fn (p &SetSpawnPositionPacket) pid() u16 {
	return 0x2b
}

pub fn (p &SetSpawnPositionPacket) name() string {
	return 'SetSpawnPositionPacket'
}

pub fn (p &SetSpawnPositionPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &SetSpawnPositionPacket) encode_payload(mut w serializer.Writer) {
	w.write_varint32(p.spawn_type)
	w.write_varint32(p.x)
	w.write_varuint32(p.y)
	w.write_varint32(p.z)
	w.bool(p.spawn_forced)
}

pub fn (mut p SetSpawnPositionPacket) decode_payload(mut r serializer.Reader) ! {
	p.spawn_type = r.read_varint32()!
	p.x = r.read_varint32()!
	p.y = r.read_varuint32()!
	p.z = r.read_varint32()!
	p.spawn_forced = r.bool()!
}
