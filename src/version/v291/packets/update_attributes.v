module packets

import protocol.serializer
import protocol.version.v291.types

pub struct UpdateAttributesPacket {
pub mut:
	runtime_entity_id u64
	attributes        []types.AttributeData
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
	w.write_varuint64(p.runtime_entity_id)
	w.write_varuint32(u32(p.attributes.len))
	for attribute in p.attributes {
		attribute.encode(mut w)
	}
}

pub fn (mut p UpdateAttributesPacket) decode_payload(mut r serializer.Reader) ! {
	p.runtime_entity_id = r.read_varuint64()!
	count := r.read_count()!
	mut attributes := []types.AttributeData{cap: serializer.prealloc(count)}
	for _ in 0 .. count {
		attributes << types.AttributeData.decode(mut r)!
	}
	p.attributes = attributes
}
