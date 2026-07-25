module enums

import serializer

pub enum ComplexInventoryTransactionType as u32 {
	normal_transaction             = 0
	inventory_mismatch             = 1
	item_use_transaction           = 2
	item_use_on_entity_transaction = 3
	item_release_transaction       = 4
}

pub fn (e ComplexInventoryTransactionType) encode(mut w serializer.Writer) {
	w.write_varuint32(u32(e))
}

pub fn ComplexInventoryTransactionType.decode(mut r serializer.Reader) !ComplexInventoryTransactionType {
	return unsafe { ComplexInventoryTransactionType(r.read_varuint32()!) }
}
