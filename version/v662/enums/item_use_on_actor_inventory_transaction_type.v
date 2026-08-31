module enums

import protocol.serializer

pub enum ItemUseOnActorInventoryTransactionType as u32 {
	interact      = 0
	attack        = 1
	item_interact = 2
}

pub fn (e ItemUseOnActorInventoryTransactionType) encode(mut w serializer.Writer) {
	w.write_varint32(i32(e))
}

pub fn ItemUseOnActorInventoryTransactionType.decode(mut r serializer.Reader) !ItemUseOnActorInventoryTransactionType {
	return unsafe { ItemUseOnActorInventoryTransactionType(u32(r.read_varint32()!)) }
}
