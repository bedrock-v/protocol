module types

import protocol.serializer
import protocol.version.v313.types as types_313
import protocol.version.v340.types as types_340

pub struct InventoryActionData {
pub mut:
	source           types_313.InventorySource
	slot             u32
	from_item        types_340.ItemData
	to_item          types_340.ItemData
	stack_network_id i32
}

pub fn (t InventoryActionData) encode(mut w serializer.Writer, has_network_ids bool) {
	t.source.encode(mut w)
	w.write_varuint32(t.slot)
	t.from_item.encode(mut w)
	t.to_item.encode(mut w)
	if has_network_ids {
		w.write_varint32(t.stack_network_id)
	}
}

pub fn InventoryActionData.decode(mut r serializer.Reader, has_network_ids bool) !InventoryActionData {
	mut t := InventoryActionData{}
	t.source = types_313.InventorySource.decode(mut r)!
	t.slot = r.read_varuint32()!
	t.from_item = types_340.ItemData.decode(mut r)!
	t.to_item = types_340.ItemData.decode(mut r)!
	if has_network_ids {
		t.stack_network_id = r.read_varint32()!
	}
	return t
}

pub fn write_inventory_actions(mut w serializer.Writer, actions []InventoryActionData, has_network_ids bool) {
	w.bool(has_network_ids)
	w.write_varuint32(u32(actions.len))
	for action in actions {
		action.encode(mut w, has_network_ids)
	}
}

pub fn read_inventory_actions(mut r serializer.Reader) !([]InventoryActionData, bool) {
	has_network_ids := r.bool()!
	count := int(r.read_varuint32()!)
	mut actions := []InventoryActionData{cap: count}
	for _ in 0 .. count {
		actions << InventoryActionData.decode(mut r, has_network_ids)!
	}
	return actions, has_network_ids
}
