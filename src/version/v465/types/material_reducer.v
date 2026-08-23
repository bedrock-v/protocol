module types

import protocol.serializer

pub struct MaterialReducerEntry {
pub mut:
	item_runtime_id i32
	count           i32
}

pub struct MaterialReducer {
pub mut:
	input_id    i32
	item_counts []MaterialReducerEntry
}

pub fn (t MaterialReducer) encode(mut w serializer.Writer) {
	w.write_varint32(t.input_id)
	w.write_varuint32(u32(t.item_counts.len))
	for entry in t.item_counts {
		w.write_varint32(entry.item_runtime_id)
		w.write_varint32(entry.count)
	}
}

pub fn MaterialReducer.decode(mut r serializer.Reader) !MaterialReducer {
	mut t := MaterialReducer{}
	t.input_id = r.read_varint32()!
	count := r.read_count()!
	t.item_counts = []MaterialReducerEntry{cap: serializer.prealloc(count)}
	for _ in 0 .. count {
		t.item_counts << MaterialReducerEntry{
			item_runtime_id: r.read_varint32()!
			count:           r.read_varint32()!
		}
	}
	return t
}
