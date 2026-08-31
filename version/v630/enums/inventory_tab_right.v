module enums

import protocol.serializer

pub enum InventoryTabRight as i32 {
	@none       = 0
	full_screen = 1
	crafting    = 2
	armor       = 3
}

pub fn (e InventoryTabRight) encode(mut w serializer.Writer) {
	w.write_varint32(i32(e))
}

pub fn InventoryTabRight.decode(mut r serializer.Reader) !InventoryTabRight {
	return unsafe { InventoryTabRight(r.read_varint32()!) }
}
