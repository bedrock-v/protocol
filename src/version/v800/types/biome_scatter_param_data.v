module types

import protocol.serializer

pub struct BiomeScatterParamData {
pub mut:
	coordinates         []BiomeCoordinateData
	eval_order          i32
	chance_percent_type i32
	chance_percent      u16
	chance_numerator    i32
	change_denominator  i32
	iterations_type     i32
	iterations          u16
}

pub fn (t BiomeScatterParamData) encode(mut w serializer.Writer) {
	w.write_varuint32(u32(t.coordinates.len))
	for e in t.coordinates {
		e.encode(mut w)
	}
	w.write_varint32(t.eval_order)
	w.write_varint32(t.chance_percent_type)
	w.le_u16(t.chance_percent)
	w.le_i32(t.chance_numerator)
	w.le_i32(t.change_denominator)
	w.write_varint32(t.iterations_type)
	w.le_u16(t.iterations)
}

pub fn BiomeScatterParamData.decode(mut r serializer.Reader) !BiomeScatterParamData {
	mut t := BiomeScatterParamData{}
	count := int(r.read_varuint32()!)
	t.coordinates = []BiomeCoordinateData{cap: count}
	for _ in 0 .. count {
		t.coordinates << BiomeCoordinateData.decode(mut r)!
	}
	t.eval_order = r.read_varint32()!
	t.chance_percent_type = r.read_varint32()!
	t.chance_percent = r.le_u16()!
	t.chance_numerator = r.le_i32()!
	t.change_denominator = r.le_i32()!
	t.iterations_type = r.read_varint32()!
	t.iterations = r.le_u16()!
	return t
}
