module types

import protocol.serializer

pub struct IntEntry {
pub mut:
	property_index u32
	data           i32
}

pub fn (t IntEntry) encode(mut w serializer.Writer) {
	w.write_varuint32(t.property_index)
	w.write_varint32(t.data)
}

pub fn IntEntry.decode(mut r serializer.Reader) !IntEntry {
	return IntEntry{
		property_index: r.read_varuint32()!
		data:           r.read_varint32()!
	}
}

pub struct FloatEntry {
pub mut:
	property_index u32
	data           f32
}

pub fn (t FloatEntry) encode(mut w serializer.Writer) {
	w.write_varuint32(t.property_index)
	w.le_f32(t.data)
}

pub fn FloatEntry.decode(mut r serializer.Reader) !FloatEntry {
	return FloatEntry{
		property_index: r.read_varuint32()!
		data:           r.le_f32()!
	}
}

pub struct PropertySyncData {
pub mut:
	int_entries_list   []IntEntry
	float_entries_list []FloatEntry
}

pub fn (t PropertySyncData) encode(mut w serializer.Writer) {
	w.write_varuint32(u32(t.int_entries_list.len))
	for e in t.int_entries_list {
		e.encode(mut w)
	}
	w.write_varuint32(u32(t.float_entries_list.len))
	for e in t.float_entries_list {
		e.encode(mut w)
	}
}

pub fn PropertySyncData.decode(mut r serializer.Reader) !PropertySyncData {
	int_count := int(r.read_varuint32()!)
	mut ints := []IntEntry{cap: int_count}
	for _ in 0 .. int_count {
		ints << IntEntry.decode(mut r)!
	}
	float_count := int(r.read_varuint32()!)
	mut floats := []FloatEntry{cap: float_count}
	for _ in 0 .. float_count {
		floats << FloatEntry.decode(mut r)!
	}
	return PropertySyncData{
		int_entries_list:   ints
		float_entries_list: floats
	}
}
