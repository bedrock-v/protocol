module packets

import serializer

pub struct DimensionDefinition {
pub mut:
	id             string
	maximum_height i32
	minimum_height i32
	generator_type i32
}

pub fn (t DimensionDefinition) encode(mut w serializer.Writer) {
	w.write_string(t.id)
	w.write_varint32(t.maximum_height)
	w.write_varint32(t.minimum_height)
	w.write_varint32(t.generator_type)
}

pub fn DimensionDefinition.decode(mut r serializer.Reader) !DimensionDefinition {
	return DimensionDefinition{
		id:             r.read_string()!
		maximum_height: r.read_varint32()!
		minimum_height: r.read_varint32()!
		generator_type: r.read_varint32()!
	}
}

pub struct DimensionDataPacket {
pub mut:
	definitions []DimensionDefinition
}

pub fn (p &DimensionDataPacket) pid() u16 {
	return 180
}

pub fn (p &DimensionDataPacket) name() string {
	return 'DimensionDataPacket'
}

pub fn (p &DimensionDataPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &DimensionDataPacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint32(u32(p.definitions.len))
	for definition in p.definitions {
		definition.encode(mut w)
	}
}

pub fn (mut p DimensionDataPacket) decode_payload(mut r serializer.Reader) ! {
	definition_count := int(r.read_varuint32()!)
	p.definitions = []DimensionDefinition{cap: definition_count}
	for _ in 0 .. definition_count {
		p.definitions << DimensionDefinition.decode(mut r)!
	}
}
