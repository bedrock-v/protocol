module enums

import serializer

pub enum ItemUseInventoryTransactionType as u32 {
	place   = 0
	use     = 1
	destroy = 2
}

pub fn (e ItemUseInventoryTransactionType) encode(mut w serializer.Writer) {
	w.write_varuint32(u32(e))
}

pub fn ItemUseInventoryTransactionType.decode(mut r serializer.Reader) !ItemUseInventoryTransactionType {
	return unsafe { ItemUseInventoryTransactionType(r.read_varuint32()!) }
}
