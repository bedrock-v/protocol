module protocol

import serializer
import types

pub const inventory_transaction_type_normal = u32(0)
pub const inventory_transaction_type_mismatch = u32(1)
pub const inventory_transaction_type_use_item = u32(2)
pub const inventory_transaction_type_use_item_on_entity = u32(3)
pub const inventory_transaction_type_release_item = u32(4)

pub const inventory_action_source_container = u32(0)
pub const inventory_action_source_world = u32(2)
pub const inventory_action_source_creative = u32(3)
pub const inventory_action_source_todo = u32(99999)

pub struct LegacySetItemSlot {
pub mut:
	container_id u8
	slots        []u8
}

pub struct InventoryAction {
pub mut:
	source_type    u32
	has_window_id  bool
	window_id      i8
	has_flags      bool
	source_flags   u32
	inventory_slot u32
	old_item       types.ItemStackWrapper
	new_item       types.ItemStackWrapper
}

pub struct UseItemTransactionData {
pub mut:
	action_type           int
	trigger_type          u8
	block_position        types.BlockPosition
	block_face            u8
	hotbar_slot           int
	held_item             types.ItemStackWrapper
	position              types.Vector3
	clicked_position      types.Vector3
	block_runtime_id      u32
	client_prediction     u8
	client_cooldown_state u8
}

pub struct UseItemOnEntityTransactionData {
pub mut:
	target_entity_runtime_id u64
	action_type              int
	hotbar_slot              int
	held_item                types.ItemStackWrapper
	position                 types.Vector3
	clicked_position         types.Vector3
}

pub struct ReleaseItemTransactionData {
pub mut:
	action_type   int
	hotbar_slot   int
	held_item     types.ItemStackWrapper
	head_position types.Vector3
}

pub struct InventoryTransactionPacket {
pub mut:
	legacy_request_id     int
	has_legacy_slots      bool
	legacy_set_item_slots []LegacySetItemSlot
	transaction_type      u32
	actions               []InventoryAction
	use_item              UseItemTransactionData
	use_item_on_entity    UseItemOnEntityTransactionData
	release_item          ReleaseItemTransactionData
}

pub fn (p &InventoryTransactionPacket) pid() u16 {
	return inventory_transaction_packet
}

pub fn (p &InventoryTransactionPacket) name() string {
	return 'InventoryTransactionPacket'
}

pub fn (p &InventoryTransactionPacket) can_be_sent_before_login() bool {
	return false
}

fn read_inventory_action(mut r serializer.Reader) !InventoryAction {
	mut a := InventoryAction{
		source_type: r.read_varuint32()!
	}
	r.bool()!
	a.has_window_id = r.bool()!
	if a.has_window_id {
		a.window_id = r.i8()!
	}
	r.bool()!
	a.has_flags = r.bool()!
	if a.has_flags {
		a.source_flags = r.read_varuint32()!
	}
	a.inventory_slot = r.read_varuint32()!
	a.old_item = r.read_network_item_stack_descriptor()!
	a.new_item = r.read_network_item_stack_descriptor()!
	return a
}

fn write_inventory_action(mut w serializer.Writer, a InventoryAction) {
	w.write_varuint32(a.source_type)
	w.bool(true)
	w.bool(a.has_window_id)
	if a.has_window_id {
		w.i8(a.window_id)
	}
	w.bool(true)
	w.bool(a.has_flags)
	if a.has_flags {
		w.write_varuint32(a.source_flags)
	}
	w.write_varuint32(a.inventory_slot)
	w.write_network_item_stack_descriptor(a.old_item)
	w.write_network_item_stack_descriptor(a.new_item)
}

fn read_use_item_transaction_data(mut r serializer.Reader) !UseItemTransactionData {
	return UseItemTransactionData{
		action_type:           r.read_varint32()!
		trigger_type:          r.u8()!
		block_position:        r.read_block_position()!
		block_face:            r.u8()!
		hotbar_slot:           r.read_varint32()!
		held_item:             r.read_network_item_stack_descriptor()!
		position:              r.read_vector3()!
		clicked_position:      r.read_vector3()!
		block_runtime_id:      r.read_varuint32()!
		client_prediction:     r.u8()!
		client_cooldown_state: r.u8()!
	}
}

fn write_use_item_transaction_data(mut w serializer.Writer, d UseItemTransactionData) {
	w.write_varint32(d.action_type)
	w.u8(d.trigger_type)
	w.write_block_position(d.block_position)
	w.u8(d.block_face)
	w.write_varint32(d.hotbar_slot)
	w.write_network_item_stack_descriptor(d.held_item)
	w.write_vector3(d.position)
	w.write_vector3(d.clicked_position)
	w.write_varuint32(d.block_runtime_id)
	w.u8(d.client_prediction)
	w.u8(d.client_cooldown_state)
}

pub fn (mut p InventoryTransactionPacket) decode_payload(mut r serializer.Reader) ! {
	p.legacy_request_id = r.read_varint32()!
	p.has_legacy_slots = r.bool()!
	if p.has_legacy_slots {
		slot_count := r.read_varuint32()!
		p.legacy_set_item_slots = []LegacySetItemSlot{}
		for _ in 0 .. slot_count {
			mut s := LegacySetItemSlot{
				container_id: r.u8()!
			}
			inner_count := r.read_varuint32()!
			s.slots = []u8{}
			for _ in 0 .. inner_count {
				s.slots << r.u8()!
			}
			p.legacy_set_item_slots << s
		}
	}
	r.bool()!
	p.transaction_type = r.read_varuint32()!
	r.bool()!
	action_count := r.read_varuint32()!
	p.actions = []InventoryAction{}
	for _ in 0 .. action_count {
		p.actions << read_inventory_action(mut r)!
	}
	match p.transaction_type {
		inventory_transaction_type_use_item {
			p.use_item = read_use_item_transaction_data(mut r)!
		}
		inventory_transaction_type_use_item_on_entity {
			p.use_item_on_entity = UseItemOnEntityTransactionData{
				target_entity_runtime_id: r.read_actor_runtime_id()!
				action_type:              r.read_varint32()!
				hotbar_slot:              r.read_varint32()!
				held_item:                r.read_network_item_stack_descriptor()!
				position:                 r.read_vector3()!
				clicked_position:         r.read_vector3()!
			}
		}
		inventory_transaction_type_release_item {
			p.release_item = ReleaseItemTransactionData{
				action_type:   r.read_varint32()!
				hotbar_slot:   r.read_varint32()!
				held_item:     r.read_network_item_stack_descriptor()!
				head_position: r.read_vector3()!
			}
		}
		else {}
	}
}

pub fn (p &InventoryTransactionPacket) encode_payload(mut w serializer.Writer) {
	w.write_varint32(p.legacy_request_id)
	w.bool(p.has_legacy_slots)
	if p.has_legacy_slots {
		w.write_varuint32(u32(p.legacy_set_item_slots.len))
		for s in p.legacy_set_item_slots {
			w.u8(s.container_id)
			w.write_varuint32(u32(s.slots.len))
			for b in s.slots {
				w.u8(b)
			}
		}
	}
	w.bool(true)
	w.write_varuint32(p.transaction_type)
	w.bool(true)
	w.write_varuint32(u32(p.actions.len))
	for a in p.actions {
		write_inventory_action(mut w, a)
	}
	match p.transaction_type {
		inventory_transaction_type_use_item {
			write_use_item_transaction_data(mut w, p.use_item)
		}
		inventory_transaction_type_use_item_on_entity {
			d := p.use_item_on_entity
			w.write_actor_runtime_id(d.target_entity_runtime_id)
			w.write_varint32(d.action_type)
			w.write_varint32(d.hotbar_slot)
			w.write_network_item_stack_descriptor(d.held_item)
			w.write_vector3(d.position)
			w.write_vector3(d.clicked_position)
		}
		inventory_transaction_type_release_item {
			d := p.release_item
			w.write_varint32(d.action_type)
			w.write_varint32(d.hotbar_slot)
			w.write_network_item_stack_descriptor(d.held_item)
			w.write_vector3(d.head_position)
		}
		else {}
	}
}
