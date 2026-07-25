module enums

import serializer

pub enum InventoryTransactionType as u32 {
	normal             = 0
	inventory_mismatch = 1
	item_use           = 2
	item_use_on_entity = 3
	item_release       = 4
}

pub fn (e InventoryTransactionType) encode(mut w serializer.Writer) {
	w.write_varuint32(u32(e))
}

pub fn InventoryTransactionType.decode(mut r serializer.Reader) !InventoryTransactionType {
	return unsafe { InventoryTransactionType(r.read_varuint32()!) }
}
