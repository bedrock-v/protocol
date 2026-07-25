module types

import serializer

pub struct BiomeCappedSurfaceData {
pub mut:
	floor_block_runtime_ids      []i32
	ceiling_block_runtime_ids    []i32
	sea_block_runtime_ids        ?i32
	foundation_block_runtime_ids ?i32
	beach_block_runtime_ids      ?i32
}

pub fn (t BiomeCappedSurfaceData) encode(mut w serializer.Writer) {
	w.write_varuint32(u32(t.floor_block_runtime_ids.len))
	for e in t.floor_block_runtime_ids {
		w.le_i32(e)
	}
	w.write_varuint32(u32(t.ceiling_block_runtime_ids.len))
	for e in t.ceiling_block_runtime_ids {
		w.le_i32(e)
	}
	if v := t.sea_block_runtime_ids {
		w.bool(true)
		w.le_i32(v)
	} else {
		w.bool(false)
	}
	if v := t.foundation_block_runtime_ids {
		w.bool(true)
		w.le_i32(v)
	} else {
		w.bool(false)
	}
	if v := t.beach_block_runtime_ids {
		w.bool(true)
		w.le_i32(v)
	} else {
		w.bool(false)
	}
}

pub fn BiomeCappedSurfaceData.decode(mut r serializer.Reader) !BiomeCappedSurfaceData {
	mut t := BiomeCappedSurfaceData{}
	floor_count := int(r.read_varuint32()!)
	t.floor_block_runtime_ids = []i32{cap: floor_count}
	for _ in 0 .. floor_count {
		t.floor_block_runtime_ids << r.le_i32()!
	}
	ceiling_count := int(r.read_varuint32()!)
	t.ceiling_block_runtime_ids = []i32{cap: ceiling_count}
	for _ in 0 .. ceiling_count {
		t.ceiling_block_runtime_ids << r.le_i32()!
	}
	if r.bool()! {
		t.sea_block_runtime_ids = r.le_i32()!
	}
	if r.bool()! {
		t.foundation_block_runtime_ids = r.le_i32()!
	}
	if r.bool()! {
		t.beach_block_runtime_ids = r.le_i32()!
	}
	return t
}
