module packets

import serializer

pub struct UpdateEquipPacket {
pub mut:
	window_id        u8
	window_type      u8
	unknown_varint   i32
	entity_unique_id i64
	namedtag         []u8
}

pub fn (p &UpdateEquipPacket) pid() u16 {
	return 81
}

pub fn (p &UpdateEquipPacket) name() string {
	return 'UpdateEquipPacket'
}

pub fn (p &UpdateEquipPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &UpdateEquipPacket) encode_payload(mut w serializer.Writer) {
	w.u8(p.window_id)
	w.u8(p.window_type)
	w.write_varint32(p.unknown_varint)
	w.write_varint64(p.entity_unique_id)
	w.write_raw(p.namedtag)
}

pub fn (mut p UpdateEquipPacket) decode_payload(mut r serializer.Reader) ! {
	p.window_id = r.u8()!
	p.window_type = r.u8()!
	p.unknown_varint = r.read_varint32()!
	p.entity_unique_id = r.read_varint64()!
	p.namedtag = r.read_raw(r.remaining())!
}
