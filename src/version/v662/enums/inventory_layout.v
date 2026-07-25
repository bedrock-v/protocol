module enums

import serializer

pub enum InventoryLayout as i32 {
	@none       = 0
	survival    = 1
	recipe_book = 2
	creative    = 3
	count       = 4
}

pub fn (e InventoryLayout) encode(mut w serializer.Writer) {
	w.write_varint32(i32(e))
}

pub fn InventoryLayout.decode(mut r serializer.Reader) !InventoryLayout {
	return unsafe { InventoryLayout(r.read_varint32()!) }
}
