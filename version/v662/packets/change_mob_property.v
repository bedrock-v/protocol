module packets

import protocol.serializer
import protocol.version.v662.types

pub struct ChangeMobPropertyPacket {
pub mut:
	actor_id               types.ActorUniqueID
	property_name          string
	bool_component_value   bool
	string_component_value string
	int_component_value    i32
	float_component_value  f32
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
	p.actor_id.encode(mut w)
	w.write_string(p.property_name)
	w.bool(p.bool_component_value)
	w.write_string(p.string_component_value)
	w.write_varint32(p.int_component_value)
	w.le_f32(p.float_component_value)
}

pub fn (mut p ChangeMobPropertyPacket) decode_payload(mut r serializer.Reader) ! {
	p.actor_id = types.ActorUniqueID.decode(mut r)!
	p.property_name = r.read_string()!
	p.bool_component_value = r.bool()!
	p.string_component_value = r.read_string()!
	p.int_component_value = r.read_varint32()!
	p.float_component_value = r.le_f32()!
}
