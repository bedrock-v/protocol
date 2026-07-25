module types

import serializer

pub struct BiomeCoordinateData {
pub mut:
	min_value_type i32
	min_value      u16
	max_value_type i32
	max_value      u16
	grid_offset    u32
	grid_step_size u32
	distribution   i32
}

pub fn (t BiomeCoordinateData) encode(mut w serializer.Writer) {
	w.write_varint32(t.min_value_type)
	w.le_u16(t.min_value)
	w.write_varint32(t.max_value_type)
	w.le_u16(t.max_value)
	w.le_u32(t.grid_offset)
	w.le_u32(t.grid_step_size)
	w.write_varint32(t.distribution)
}

pub fn BiomeCoordinateData.decode(mut r serializer.Reader) !BiomeCoordinateData {
	return BiomeCoordinateData{
		min_value_type: r.read_varint32()!
		min_value:      r.le_u16()!
		max_value_type: r.read_varint32()!
		max_value:      r.le_u16()!
		grid_offset:    r.le_u32()!
		grid_step_size: r.le_u32()!
		distribution:   r.read_varint32()!
	}
}
