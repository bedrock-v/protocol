module types

import protocol.serializer

pub struct InventoryAction {
pub mut:
	source               InventorySource
	slot                 u32
	from_item_descriptor NetworkItemStackDescriptor
	to_item_descriptor   NetworkItemStackDescriptor
}

pub fn (t InventoryAction) encode(mut w serializer.Writer) {
	t.source.encode(mut w)
	w.write_varuint32(t.slot)
	t.from_item_descriptor.encode(mut w)
	t.to_item_descriptor.encode(mut w)
}

pub fn InventoryAction.decode(mut r serializer.Reader) !InventoryAction {
	return InventoryAction{
		source:               InventorySource.decode(mut r)!
		slot:                 r.read_varuint32()!
		from_item_descriptor: NetworkItemStackDescriptor.decode(mut r)!
		to_item_descriptor:   NetworkItemStackDescriptor.decode(mut r)!
	}
}
