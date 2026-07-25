module enums

import serializer

pub enum InventoryLeftTabIndex as i32 {
	@none               = 0
	recipe_construction = 1
	recipe_equipment    = 2
	recipe_items        = 3
	recipe_nature       = 4
	recipe_search       = 5
	survival            = 6
	count               = 7
}

pub fn (e InventoryLeftTabIndex) encode(mut w serializer.Writer) {
	w.write_varint32(i32(e))
}

pub fn InventoryLeftTabIndex.decode(mut r serializer.Reader) !InventoryLeftTabIndex {
	return unsafe { InventoryLeftTabIndex(r.read_varint32()!) }
}
