module types

import protocol.serializer
import protocol.version.v291.types as types_291
import protocol.version.v431.types as types_431

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

pub struct ItemUseTransaction {
pub mut:
	legacy_request_id i32
	legacy_slots      []LegacySetItemSlotData
	actions           []types_431.InventoryActionData
	action_type       u32
	block_position    types_291.BlockPosition
	block_face        i32
	hotbar_slot       i32
	item_in_hand      types_431.ItemData
	player_position   types_291.Vector3f
	click_position    types_291.Vector3f
	block_runtime_id  u32
}

pub fn (t ItemUseTransaction) encode(mut w serializer.Writer) {
	w.write_varint32(t.legacy_request_id)
	if t.legacy_request_id < -1 && (t.legacy_request_id & 1) == 0 {
		w.write_varuint32(u32(t.legacy_slots.len))
		for slot in t.legacy_slots {
			slot.encode(mut w)
		}
	}
	w.write_varuint32(u32(t.actions.len))
	for action in t.actions {
		action.encode(mut w)
	}
	w.write_varuint32(t.action_type)
	t.block_position.encode(mut w)
	w.write_varint32(t.block_face)
	w.write_varint32(t.hotbar_slot)
	t.item_in_hand.encode(mut w)
	t.player_position.encode(mut w)
	t.click_position.encode(mut w)
	w.write_varuint32(t.block_runtime_id)
}

pub fn ItemUseTransaction.decode(mut r serializer.Reader) !ItemUseTransaction {
	mut t := ItemUseTransaction{}
	t.legacy_request_id = r.read_varint32()!
	if t.legacy_request_id < -1 && (t.legacy_request_id & 1) == 0 {
		slot_count := int(r.read_varuint32()!)
		t.legacy_slots = []LegacySetItemSlotData{cap: slot_count}
		for _ in 0 .. slot_count {
			t.legacy_slots << LegacySetItemSlotData.decode(mut r)!
		}
	}
	action_count := int(r.read_varuint32()!)
	t.actions = []types_431.InventoryActionData{cap: action_count}
	for _ in 0 .. action_count {
		t.actions << types_431.InventoryActionData.decode(mut r)!
	}
	t.action_type = r.read_varuint32()!
	t.block_position = types_291.BlockPosition.decode(mut r)!
	t.block_face = r.read_varint32()!
	t.hotbar_slot = r.read_varint32()!
	t.item_in_hand = types_431.ItemData.decode(mut r)!
	t.player_position = types_291.Vector3f.decode(mut r)!
	t.click_position = types_291.Vector3f.decode(mut r)!
	t.block_runtime_id = r.read_varuint32()!
	return t
}
