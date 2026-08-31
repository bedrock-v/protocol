module enums

import protocol.serializer

pub enum ItemReleaseInventoryTransactionType as u32 {
	release = 0
	use     = 1
}

pub fn (e ItemReleaseInventoryTransactionType) encode(mut w serializer.Writer) {
	w.write_varint32(i32(e))
}

pub fn ItemReleaseInventoryTransactionType.decode(mut r serializer.Reader) !ItemReleaseInventoryTransactionType {
	return unsafe { ItemReleaseInventoryTransactionType(u32(r.read_varint32()!)) }
}
