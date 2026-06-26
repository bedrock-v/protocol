module src

import src.serializer

pub struct ChangeMobPropertyPacket {
pub mut:
	actor_unique_id i64
	property_name   string
	bool_value      bool
	string_value    string
	int_value       int
	float_value     f32
}

pub fn (p &ChangeMobPropertyPacket) pid() u16 {
	return change_mob_property_packet
}

pub fn (p &ChangeMobPropertyPacket) name() string {
	return 'ChangeMobPropertyPacket'
}

pub fn (p &ChangeMobPropertyPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p ChangeMobPropertyPacket) decode_payload(mut r serializer.Reader) ! {
	p.actor_unique_id = r.read_actor_unique_id()!
	p.property_name = r.read_string()!
	p.bool_value = r.bool()!
	p.string_value = r.read_string()!
	p.int_value = r.read_varint32()!
	p.float_value = r.le_f32()!
}

pub fn (p &ChangeMobPropertyPacket) encode_payload(mut w serializer.Writer) {
	w.write_actor_unique_id(p.actor_unique_id)
	w.write_string(p.property_name)
	w.bool(p.bool_value)
	w.write_string(p.string_value)
	w.write_varint32(p.int_value)
	w.le_f32(p.float_value)
}
