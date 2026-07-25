module enums

import serializer

pub enum InventoryRightTabIndex as i32 {
	@none       = 0
	full_screen = 1
	crafting    = 2
	armor       = 3
	count       = 4
}

pub fn (e InventoryRightTabIndex) encode(mut w serializer.Writer) {
	w.write_varint32(i32(e))
}

pub fn InventoryRightTabIndex.decode(mut r serializer.Reader) !InventoryRightTabIndex {
	return unsafe { InventoryRightTabIndex(r.read_varint32()!) }
}
