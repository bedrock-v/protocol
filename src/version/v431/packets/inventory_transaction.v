module packets

import serializer
import version.v291.types as types_291
import version.v291.enums as enums_291
import version.v431.types

pub struct LegacySetItemSlotData {
pub mut:
	container_id u8
	slots        []u8
}

pub fn (t LegacySetItemSlotData) encode(mut w serializer.Writer) {
	w.u8(t.container_id)
	w.write_string_bytes(t.slots)
}

pub fn LegacySetItemSlotData.decode(mut r serializer.Reader) !LegacySetItemSlotData {
	return LegacySetItemSlotData{
		container_id: r.u8()!
		slots:        r.read_string_bytes()!
	}
}

pub struct InventoryTransactionPacket {
pub mut:
	legacy_request_id i32
	legacy_slots      []LegacySetItemSlotData
	transaction_type  enums_291.InventoryTransactionType
	actions           []types.InventoryActionData
	item_use          types.ItemUseTransaction
	runtime_entity_id u64
	action_type       u32
	hotbar_slot       i32
	item_in_hand      types.ItemData
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
	if p.legacy_request_id < -1 && (p.legacy_request_id & 1) == 0 {
		w.write_varuint32(u32(p.legacy_slots.len))
		for slot in p.legacy_slots {
			slot.encode(mut w)
		}
	}
	p.transaction_type.encode(mut w)
	types.write_inventory_actions(mut w, p.actions)
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
	if p.legacy_request_id < -1 && (p.legacy_request_id & 1) == 0 {
		slot_count := int(r.read_varuint32()!)
		p.legacy_slots = []LegacySetItemSlotData{cap: slot_count}
		for _ in 0 .. slot_count {
			p.legacy_slots << LegacySetItemSlotData.decode(mut r)!
		}
	}
	p.transaction_type = enums_291.InventoryTransactionType.decode(mut r)!
	p.actions = types.read_inventory_actions(mut r)!
	match p.transaction_type {
		.item_use {
			p.item_use = types.ItemUseTransaction.decode(mut r)!
		}
		.item_use_on_entity {
			p.runtime_entity_id = r.read_varuint64()!
			p.action_type = r.read_varuint32()!
			p.hotbar_slot = r.read_varint32()!
			p.item_in_hand = types.ItemData.decode(mut r)!
			p.player_position = types_291.Vector3f.decode(mut r)!
			p.click_position = types_291.Vector3f.decode(mut r)!
		}
		.item_release {
			p.action_type = r.read_varuint32()!
			p.hotbar_slot = r.read_varint32()!
			p.item_in_hand = types.ItemData.decode(mut r)!
			p.head_position = types_291.Vector3f.decode(mut r)!
		}
		else {}
	}
}
