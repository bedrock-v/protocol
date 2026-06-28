module protocol

import serializer

pub struct DimensionDefinition {
pub mut:
	name           string
	max_height     int
	min_height     int
	generator      int
	dimension_type int
}

pub struct DimensionDataPacket {
pub mut:
	definitions []DimensionDefinition
}

pub fn (p &DimensionDataPacket) pid() u16 {
	return dimension_data_packet
}

pub fn (p &DimensionDataPacket) name() string {
	return 'DimensionDataPacket'
}

pub fn (p &DimensionDataPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p DimensionDataPacket) decode_payload(mut r serializer.Reader) ! {
	count := r.read_varuint32()!
	p.definitions = []DimensionDefinition{}
	for _ in 0 .. count {
		p.definitions << DimensionDefinition{
			name:           r.read_string()!
			max_height:     r.read_varint32()!
			min_height:     r.read_varint32()!
			generator:      r.read_varint32()!
			dimension_type: r.read_varint32()!
		}
	}
}

pub fn (p &DimensionDataPacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint32(u32(p.definitions.len))
	for d in p.definitions {
		w.write_string(d.name)
		w.write_varint32(d.max_height)
		w.write_varint32(d.min_height)
		w.write_varint32(d.generator)
		w.write_varint32(d.dimension_type)
	}
}
