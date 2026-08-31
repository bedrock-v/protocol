module enums

import protocol.serializer

pub enum InventoryLayout as i32 {
	@none            = 0
	inventory_only   = 1
	default          = 2
	recipe_book_only = 3
}

pub fn (e InventoryLayout) encode(mut w serializer.Writer) {
	w.write_varint32(i32(e))
}

pub fn InventoryLayout.decode(mut r serializer.Reader) !InventoryLayout {
	return unsafe { InventoryLayout(r.read_varint32()!) }
}
