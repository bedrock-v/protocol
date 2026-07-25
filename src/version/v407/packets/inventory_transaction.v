module packets

import serializer
import version.v291.enums as enums_291
import version.v291.types as types_291
import version.v340.types as types_340
import version.v407.types

pub struct LegacySetItemSlotData {
pub mut:
	container_id i8
	slots        []u8
}

pub fn (t LegacySetItemSlotData) encode(mut w serializer.Writer) {
	w.i8(t.container_id)
	w.write_string_bytes(t.slots)
}

pub fn LegacySetItemSlotData.decode(mut r serializer.Reader) !LegacySetItemSlotData {
	return LegacySetItemSlotData{
		container_id: r.i8()!
		slots:        r.read_string_bytes()!
	}
}

pub struct InventoryTransactionPacket {
pub mut:
	legacy_request_id i32
	legacy_slots      []LegacySetItemSlotData
	transaction_type  enums_291.InventoryTransactionType
	has_network_ids   bool
	actions           []types.InventoryActionData
	item_use          types_340.ItemUseTransaction
	runtime_entity_id u64
	action_type       u32
	hotbar_slot       i32
	item_in_hand      types_340.ItemData
	player_position   types_291.Vector3f
	click_position    types_291.Vector3f
	head_position     types_291.Vector3f
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
	w.write_varint32(p.legacy_request_id)
	if p.legacy_request_id < -1 && p.legacy_request_id & 1 == 0 {
		w.write_varuint32(u32(p.legacy_slots.len))
		for slot_data in p.legacy_slots {
			slot_data.encode(mut w)
		}
	}
	p.transaction_type.encode(mut w)
	types.write_inventory_actions(mut w, p.actions, p.has_network_ids)
	match p.transaction_type {
		.item_use {
			p.item_use.encode(mut w)
		}
		.item_use_on_entity {
			w.write_varuint64(p.runtime_entity_id)
			w.write_varuint32(p.action_type)
			w.write_varint32(p.hotbar_slot)
			p.item_in_hand.encode(mut w)
			p.player_position.encode(mut w)
			p.click_position.encode(mut w)
		}
		.item_release {
			w.write_varuint32(p.action_type)
			w.write_varint32(p.hotbar_slot)
			p.item_in_hand.encode(mut w)
			p.head_position.encode(mut w)
		}
		else {}
	}
}

pub fn (mut p InventoryTransactionPacket) decode_payload(mut r serializer.Reader) ! {
	p.legacy_request_id = r.read_varint32()!
	if p.legacy_request_id < -1 && p.legacy_request_id & 1 == 0 {
		count := int(r.read_varuint32()!)
		p.legacy_slots = []LegacySetItemSlotData{cap: count}
		for _ in 0 .. count {
			p.legacy_slots << LegacySetItemSlotData.decode(mut r)!
		}
	}
	p.transaction_type = enums_291.InventoryTransactionType.decode(mut r)!
	p.actions, p.has_network_ids = types.read_inventory_actions(mut r)!
	match p.transaction_type {
		.item_use {
			p.item_use = types_340.ItemUseTransaction.decode(mut r)!
		}
		.item_use_on_entity {
			p.runtime_entity_id = r.read_varuint64()!
			p.action_type = r.read_varuint32()!
			p.hotbar_slot = r.read_varint32()!
			p.item_in_hand = types_340.ItemData.decode(mut r)!
			p.player_position = types_291.Vector3f.decode(mut r)!
			p.click_position = types_291.Vector3f.decode(mut r)!
		}
		.item_release {
			p.action_type = r.read_varuint32()!
			p.hotbar_slot = r.read_varint32()!
			p.item_in_hand = types_340.ItemData.decode(mut r)!
			p.head_position = types_291.Vector3f.decode(mut r)!
		}
		else {}
	}
}
