module packets

import protocol.serializer

pub struct SetSpawnPositionPacket {
pub mut:
	unknown      i32
	x            i32
	y            u32
	z            i32
	unknown_bool bool
}

pub fn (p &SetSpawnPositionPacket) pid() u16 {
	return 0x2c
}

pub fn (p &SetSpawnPositionPacket) name() string {
	return 'SetSpawnPositionPacket'
}

pub fn (p &SetSpawnPositionPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &SetSpawnPositionPacket) encode_payload(mut w serializer.Writer) {
	w.write_varint32(p.unknown)
	w.write_varint32(p.x)
	w.write_varuint32(p.y)
	w.write_varint32(p.z)
	w.u8(if p.unknown_bool { u8(1) } else { u8(0) })
}

pub fn (mut p SetSpawnPositionPacket) decode_payload(mut r serializer.Reader) ! {
	p.unknown = r.read_varint32()!
	p.x = r.read_varint32()!
	p.y = r.read_varuint32()!
	p.z = r.read_varint32()!
	p.unknown_bool = r.u8()! > 0
}
