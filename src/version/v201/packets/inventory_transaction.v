module packets

import protocol.serializer
import protocol.version.v137.types

pub struct NetworkInventoryAction {
pub mut:
	source_type    u32
	window_id      i32
	unknown        u32
	inventory_slot u32
	old_item       types.ItemData
	new_item       types.ItemData
}

fn (a NetworkInventoryAction) write(mut w serializer.Writer) {
	w.write_varuint32(a.source_type)
	match a.source_type {
		0 {
			w.write_varint32(a.window_id)
		}
		2 {
			w.write_varuint32(a.unknown)
		}
		3 {}
		99999 {
			w.write_varint32(a.window_id)
		}
		else {}
	}
	w.write_varuint32(a.inventory_slot)
	a.old_item.encode(mut w)
	a.new_item.encode(mut w)
}

fn read_network_inventory_action(mut r serializer.Reader) !NetworkInventoryAction {
	mut a := NetworkInventoryAction{}
	a.source_type = r.read_varuint32()!
	match a.source_type {
		0 {
			a.window_id = r.read_varint32()!
		}
		2 {
			a.unknown = r.read_varuint32()!
		}
		3 {}
		99999 {
			a.window_id = r.read_varint32()!
		}
		else {}
	}
	a.inventory_slot = r.read_varuint32()!
	a.old_item = types.ItemData.decode(mut r)!
	a.new_item = types.ItemData.decode(mut r)!
	return a
}

pub struct InventoryTransactionPacket {
pub mut:
	transaction_type  u32
	actions           []NetworkInventoryAction
	action_type       u32
	block_pos         types.BlockPosition
	face              i32
	hotbar_slot       i32
	item_in_hand      types.ItemData
	player_pos        types.Vector3f
	click_pos         types.Vector3f
	entity_runtime_id u64
	head_pos          types.Vector3f
}

pub fn (p &InventoryTransactionPacket) pid() u16 {
	return 30
}

pub fn (p &InventoryTransactionPacket) name() string {
	return 'InventoryTransactionPacket'
}

pub fn (p &InventoryTransactionPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &InventoryTransactionPacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint32(p.transaction_type)
	w.write_varuint32(u32(p.actions.len))
	for action in p.actions {
		action.write(mut w)
	}
	match p.transaction_type {
		2 {
			w.write_varuint32(p.action_type)
			p.block_pos.encode(mut w)
			w.write_varint32(p.face)
			w.write_varint32(p.hotbar_slot)
			p.item_in_hand.encode(mut w)
			p.player_pos.encode(mut w)
			p.click_pos.encode(mut w)
		}
		3 {
			w.write_varuint64(p.entity_runtime_id)
			w.write_varuint32(p.action_type)
			w.write_varint32(p.hotbar_slot)
			p.item_in_hand.encode(mut w)
			p.player_pos.encode(mut w)
			p.click_pos.encode(mut w)
		}
		4 {
			w.write_varuint32(p.action_type)
			w.write_varint32(p.hotbar_slot)
			p.item_in_hand.encode(mut w)
			p.head_pos.encode(mut w)
		}
		else {}
	}
}

pub fn (mut p InventoryTransactionPacket) decode_payload(mut r serializer.Reader) ! {
	p.transaction_type = r.read_varuint32()!
	count := int(r.read_varuint32()!)
	p.actions = []NetworkInventoryAction{cap: count}
	for _ in 0 .. count {
		p.actions << read_network_inventory_action(mut r)!
	}
	match p.transaction_type {
		2 {
			p.action_type = r.read_varuint32()!
			p.block_pos = types.BlockPosition.decode(mut r)!
			p.face = r.read_varint32()!
			p.hotbar_slot = r.read_varint32()!
			p.item_in_hand = types.ItemData.decode(mut r)!
			p.player_pos = types.Vector3f.decode(mut r)!
			p.click_pos = types.Vector3f.decode(mut r)!
		}
		3 {
			p.entity_runtime_id = r.read_varuint64()!
			p.action_type = r.read_varuint32()!
			p.hotbar_slot = r.read_varint32()!
			p.item_in_hand = types.ItemData.decode(mut r)!
			p.player_pos = types.Vector3f.decode(mut r)!
			p.click_pos = types.Vector3f.decode(mut r)!
		}
		4 {
			p.action_type = r.read_varuint32()!
			p.hotbar_slot = r.read_varint32()!
			p.item_in_hand = types.ItemData.decode(mut r)!
			p.head_pos = types.Vector3f.decode(mut r)!
		}
		else {}
	}
}
