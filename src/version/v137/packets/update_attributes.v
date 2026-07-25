module packets

import serializer
import version.v137.types

pub struct UpdateAttributesPacket {
pub mut:
	entity_runtime_id u64
	entries           []types.AttributeData
}

pub fn (p &UpdateAttributesPacket) pid() u16 {
	return 29
}

pub fn (p &UpdateAttributesPacket) name() string {
	return 'UpdateAttributesPacket'
}

pub fn (p &UpdateAttributesPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &UpdateAttributesPacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint64(p.entity_runtime_id)
	types.write_attribute_list(mut w, p.entries)
}

pub fn (mut p UpdateAttributesPacket) decode_payload(mut r serializer.Reader) ! {
	p.entity_runtime_id = r.read_varuint64()!
	p.entries = types.read_attribute_list(mut r)!
}
