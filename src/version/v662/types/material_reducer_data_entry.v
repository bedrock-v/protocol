module types

import protocol.serializer

pub struct MaterialReducerDataEntryIdAndCount {
pub mut:
	id    i32
	count i32
}

pub fn (t MaterialReducerDataEntryIdAndCount) encode(mut w serializer.Writer) {
	w.write_varint32(t.id)
	w.write_varint32(t.count)
}

pub fn MaterialReducerDataEntryIdAndCount.decode(mut r serializer.Reader) !MaterialReducerDataEntryIdAndCount {
	return MaterialReducerDataEntryIdAndCount{
		id:    r.read_varint32()!
		count: r.read_varint32()!
	}
}

pub struct MaterialReducerDataEntry {
pub mut:
	input          i32
	ids_and_counts []MaterialReducerDataEntryIdAndCount
}

pub fn (t MaterialReducerDataEntry) encode(mut w serializer.Writer) {
	w.write_varint32(t.input)
	w.write_varuint32(u32(t.ids_and_counts.len))
	for e in t.ids_and_counts {
		e.encode(mut w)
	}
}

pub fn MaterialReducerDataEntry.decode(mut r serializer.Reader) !MaterialReducerDataEntry {
	input := r.read_varint32()!
	count := r.read_count()!
	mut items := []MaterialReducerDataEntryIdAndCount{cap: serializer.prealloc(count)}
	for _ in 0 .. count {
		items << MaterialReducerDataEntryIdAndCount.decode(mut r)!
	}
	return MaterialReducerDataEntry{
		input:          input
		ids_and_counts: items
	}
}
