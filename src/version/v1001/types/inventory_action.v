module types

import protocol.serializer
import protocol.version.v662.types as types_662
import protocol.version.v975.types as types_975

pub struct InventoryAction {
pub mut:
	source               types_662.InventorySource
	slot                 u32
	from_item_descriptor types_975.NetworkItemStackDescriptorV2
	to_item_descriptor   types_975.NetworkItemStackDescriptorV2
}

pub fn (t InventoryAction) encode(mut w serializer.Writer) {
	t.source.encode(mut w)
	w.write_varuint32(t.slot)
	t.from_item_descriptor.encode(mut w)
	t.to_item_descriptor.encode(mut w)
}

pub fn InventoryAction.decode(mut r serializer.Reader) !InventoryAction {
	return InventoryAction{
		source:               types_662.InventorySource.decode(mut r)!
		slot:                 r.read_varuint32()!
		from_item_descriptor: types_975.NetworkItemStackDescriptorV2.decode(mut r)!
		to_item_descriptor:   types_975.NetworkItemStackDescriptorV2.decode(mut r)!
	}
}
