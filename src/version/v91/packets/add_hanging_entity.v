module packets

import protocol.serializer

pub struct AddHangingEntityPacket {
pub mut:
	entity_unique_id  i32
	entity_runtime_id i32
	x                 i32
	y                 u8
	z                 i32
	unknown           i32
}

pub fn (p &AddHangingEntityPacket) pid() u16 {
	return 0x11
}

pub fn (p &AddHangingEntityPacket) name() string {
	return 'AddHangingEntityPacket'
}

pub fn (p &AddHangingEntityPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &AddHangingEntityPacket) encode_payload(mut w serializer.Writer) {
	w.write_varint32(p.entity_unique_id)
	w.write_varint32(p.entity_runtime_id)
	w.write_varint32(p.x)
	w.u8(p.y)
	w.write_varint32(p.z)
	w.write_varint32(p.unknown)
}

pub fn (mut p AddHangingEntityPacket) decode_payload(mut r serializer.Reader) ! {
	p.entity_unique_id = r.read_varint32()!
	p.entity_runtime_id = r.read_varint32()!
	p.x = r.read_varint32()!
	p.y = r.u8()!
	p.z = r.read_varint32()!
	p.unknown = r.read_varint32()!
}
