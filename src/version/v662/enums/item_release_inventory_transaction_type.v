module enums

import serializer

pub enum ItemReleaseInventoryTransactionType as u32 {
	release = 0
	use     = 1
}

pub fn (e ItemReleaseInventoryTransactionType) encode(mut w serializer.Writer) {
	w.write_varuint32(u32(e))
}

pub fn ItemReleaseInventoryTransactionType.decode(mut r serializer.Reader) !ItemReleaseInventoryTransactionType {
	return unsafe { ItemReleaseInventoryTransactionType(r.read_varuint32()!) }
}
