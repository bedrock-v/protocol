module packets

import serializer
import nbt

pub struct UpdateEquipPacket {
pub mut:
	window_id        u8
	window_type      u8
	size             i32
	unique_entity_id i64
	tag              nbt.RootTag
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
	w.write_varint32(p.size)
	w.write_varint64(p.unique_entity_id)
	w.write_nbt_compound_root(p.tag)
}

pub fn (mut p UpdateEquipPacket) decode_payload(mut r serializer.Reader) ! {
	p.window_id = r.u8()!
	p.window_type = r.u8()!
	p.size = r.read_varint32()!
	p.unique_entity_id = r.read_varint64()!
	p.tag = r.read_nbt_compound_root()!
}
