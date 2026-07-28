module packets

import protocol.serializer

pub struct ChangeMobPropertyPacket {
pub mut:
	unique_entity_id i64
	property         string
	bool_value       bool
	string_value     string
	int_value        i32
	float_value      f32
}

pub fn (p &ChangeMobPropertyPacket) pid() u16 {
	return 182
}

pub fn (p &ChangeMobPropertyPacket) name() string {
	return 'ChangeMobPropertyPacket'
}

pub fn (p &ChangeMobPropertyPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &ChangeMobPropertyPacket) encode_payload(mut w serializer.Writer) {
	w.write_varint64(p.unique_entity_id)
	w.write_string(p.property)
	w.bool(p.bool_value)
	w.write_string(p.string_value)
	w.write_varint32(p.int_value)
	w.le_f32(p.float_value)
}

pub fn (mut p ChangeMobPropertyPacket) decode_payload(mut r serializer.Reader) ! {
	p.unique_entity_id = r.read_varint64()!
	p.property = r.read_string()!
	p.bool_value = r.bool()!
	p.string_value = r.read_string()!
	p.int_value = r.read_varint32()!
	p.float_value = r.le_f32()!
}
