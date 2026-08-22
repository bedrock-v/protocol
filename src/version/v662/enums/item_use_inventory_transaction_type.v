module enums

import protocol.serializer

pub enum ItemUseInventoryTransactionType as u32 {
	place   = 0
	use     = 1
	destroy = 2
}

pub fn (e ItemUseInventoryTransactionType) encode(mut w serializer.Writer) {
	w.write_varint32(i32(e))
}

pub fn ItemUseInventoryTransactionType.decode(mut r serializer.Reader) !ItemUseInventoryTransactionType {
	return unsafe { ItemUseInventoryTransactionType(u32(r.read_varint32()!)) }
}
