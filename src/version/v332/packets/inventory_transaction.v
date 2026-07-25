module packets

import serializer
import version.v291.types as types_291
import version.v291.enums
import version.v332.types

pub struct InventoryTransactionPacket {
pub mut:
	transaction_type  enums.InventoryTransactionType
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
	p.transaction_type.encode(mut w)
	w.write_varuint32(u32(p.actions.len))
	for a in p.actions {
		a.encode(mut w)
	}
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
	p.transaction_type = enums.InventoryTransactionType.decode(mut r)!
	count := int(r.read_varuint32()!)
	p.actions = []types.InventoryActionData{cap: count}
	for _ in 0 .. count {
		p.actions << types.InventoryActionData.decode(mut r)!
	}
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
