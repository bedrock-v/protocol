module types

import protocol.serializer
import protocol.version.v313.types as types_313

pub struct InventoryActionData {
pub mut:
	source    types_313.InventorySource
	slot      u32
	from_item ItemData
	to_item   ItemData
}

pub fn (t InventoryActionData) encode(mut w serializer.Writer) {
	t.source.encode(mut w)
	w.write_varuint32(t.slot)
	t.from_item.encode(mut w)
	t.to_item.encode(mut w)
}

pub fn InventoryActionData.decode(mut r serializer.Reader) !InventoryActionData {
	return InventoryActionData{
		source:    types_313.InventorySource.decode(mut r)!
		slot:      r.read_varuint32()!
		from_item: ItemData.decode(mut r)!
		to_item:   ItemData.decode(mut r)!
	}
}

pub fn write_inventory_actions(mut w serializer.Writer, actions []InventoryActionData) {
	w.write_varuint32(u32(actions.len))
	for action in actions {
		action.encode(mut w)
	}
}

pub fn read_inventory_actions(mut r serializer.Reader) ![]InventoryActionData {
	count := int(r.read_varuint32()!)
	mut actions := []InventoryActionData{cap: count}
	for _ in 0 .. count {
		actions << InventoryActionData.decode(mut r)!
	}
	return actions
}
