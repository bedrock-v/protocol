module enums

import protocol.serializer

pub enum InventoryTabLeft as i32 {
	@none               = 0
	recipe_construction = 1
	recipe_equipment    = 2
	recipe_items        = 3
	recipe_nature       = 4
	recipe_search       = 5
	survival            = 6
}

pub fn (e InventoryTabLeft) encode(mut w serializer.Writer) {
	w.write_varint32(i32(e))
}

pub fn InventoryTabLeft.decode(mut r serializer.Reader) !InventoryTabLeft {
	return unsafe { InventoryTabLeft(r.read_varint32()!) }
}
