module types

import protocol.serializer

pub struct BiomeSurfaceMaterialData {
pub mut:
	top_block_runtime_id        i32
	mid_block_runtime_id        i32
	sea_floor_block_runtime_id  i32
	foundation_block_runtime_id i32
	sea_block_runtime_id        i32
	sea_floor_depth             i32
}

pub fn (t BiomeSurfaceMaterialData) encode(mut w serializer.Writer) {
	w.le_i32(t.top_block_runtime_id)
	w.le_i32(t.mid_block_runtime_id)
	w.le_i32(t.sea_floor_block_runtime_id)
	w.le_i32(t.foundation_block_runtime_id)
	w.le_i32(t.sea_block_runtime_id)
	w.le_i32(t.sea_floor_depth)
}

pub fn BiomeSurfaceMaterialData.decode(mut r serializer.Reader) !BiomeSurfaceMaterialData {
	return BiomeSurfaceMaterialData{
		top_block_runtime_id:        r.le_i32()!
		mid_block_runtime_id:        r.le_i32()!
		sea_floor_block_runtime_id:  r.le_i32()!
		foundation_block_runtime_id: r.le_i32()!
		sea_block_runtime_id:        r.le_i32()!
		sea_floor_depth:             r.le_i32()!
	}
}
