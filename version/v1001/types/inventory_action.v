module types

import protocol.serializer
import protocol.version.v662.types as types_662
import protocol.version.v975.types as types_975

pub const inventory_action_source_container = u32(0)
pub const inventory_action_source_world = u32(2)
pub const inventory_action_source_creative = u32(3)
pub const inventory_action_source_todo = u32(99999)

pub struct InventoryAction {
pub mut:
	source_type          u32
	window_id            i8
	source_flags         u32
	slot                 u32
	from_item_descriptor types_975.NetworkItemStackDescriptorV2
	to_item_descriptor   types_975.NetworkItemStackDescriptorV2
}

pub fn (t InventoryAction) encode(mut w serializer.Writer) {
	w.write_varuint32(t.source_type)
	w.bool(true)
	has_container_id := t.source_type == inventory_action_source_container
		|| t.source_type == inventory_action_source_todo
	w.bool(has_container_id)
	if has_container_id {
		w.i8(t.window_id)
	}
	w.bool(true)
	has_flags := t.source_type == inventory_action_source_world
	w.bool(has_flags)
	if has_flags {
		w.write_varuint32(t.source_flags)
	}
	w.write_varuint32(t.slot)
	t.from_item_descriptor.encode(mut w)
	t.to_item_descriptor.encode(mut w)
}

pub fn InventoryAction.decode(mut r serializer.Reader) !InventoryAction {
	mut t := InventoryAction{}
	t.source_type = r.read_varuint32()!
	_ = r.bool()!
	has_container_id := r.bool()!
	if has_container_id {
		t.window_id = r.i8()!
	}
	_ = r.bool()!
	has_flags := r.bool()!
	if has_flags {
		t.source_flags = r.read_varuint32()!
	}
	t.slot = r.read_varuint32()!
	t.from_item_descriptor = types_975.NetworkItemStackDescriptorV2.decode(mut r)!
	t.to_item_descriptor = types_975.NetworkItemStackDescriptorV2.decode(mut r)!
	return t
}

pub struct LegacyInventoryAction {
pub mut:
	source_type          u32
	window_id            i8
	source_flags         u32
	slot                 u32
	from_item_descriptor types_662.NetworkItemStackDescriptor
	to_item_descriptor   types_662.NetworkItemStackDescriptor
}

pub fn (t LegacyInventoryAction) encode(mut w serializer.Writer) {
	w.write_varuint32(t.source_type)
	match t.source_type {
		inventory_action_source_container, inventory_action_source_todo {
			w.write_varint32(i32(t.window_id))
		}
		inventory_action_source_world {
			w.write_varuint32(t.source_flags)
		}
		else {}
	}
	w.write_varuint32(t.slot)
	t.from_item_descriptor.encode(mut w)
	t.to_item_descriptor.encode(mut w)
}

pub fn LegacyInventoryAction.decode(mut r serializer.Reader) !LegacyInventoryAction {
	mut t := LegacyInventoryAction{}
	t.source_type = r.read_varuint32()!
	match t.source_type {
		inventory_action_source_container, inventory_action_source_todo {
			t.window_id = i8(r.read_varint32()!)
		}
		inventory_action_source_world {
			t.source_flags = r.read_varuint32()!
		}
		else {}
	}
	t.slot = r.read_varuint32()!
	t.from_item_descriptor = types_662.NetworkItemStackDescriptor.decode(mut r)!
	t.to_item_descriptor = types_662.NetworkItemStackDescriptor.decode(mut r)!
	return t
}
