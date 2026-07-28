module types

import protocol.serializer
import protocol.version.v662.enums
import protocol.version.v662.types as types_662
import protocol.version.v944.types as types_944

pub struct ContainerSlotEntry {
pub mut:
	container_enum_name string
	slots               []i8
}

pub fn (t ContainerSlotEntry) encode(mut w serializer.Writer) {
	w.write_string(t.container_enum_name)
	w.write_varuint32(u32(t.slots.len))
	for s in t.slots {
		w.i8(s)
	}
}

pub fn ContainerSlotEntry.decode(mut r serializer.Reader) !ContainerSlotEntry {
	name := r.read_string()!
	count := int(r.read_varuint32()!)
	mut slots := []i8{cap: count}
	for _ in 0 .. count {
		slots << r.i8()!
	}
	return ContainerSlotEntry{
		container_enum_name: name
		slots:               slots
	}
}

pub enum PredictedResult as i32 {
	failure = 0
	success = 1
}

pub fn (e PredictedResult) encode(mut w serializer.Writer) {
	w.write_varint32(i32(e))
}

pub fn PredictedResult.decode(mut r serializer.Reader) !PredictedResult {
	return unsafe { PredictedResult(r.read_varint32()!) }
}

pub enum TriggerType as i32 {
	unknown         = 0
	player_input    = 1
	simulation_tick = 2
}

pub fn (e TriggerType) encode(mut w serializer.Writer) {
	w.write_varint32(i32(e))
}

pub fn TriggerType.decode(mut r serializer.Reader) !TriggerType {
	return unsafe { TriggerType(r.read_varint32()!) }
}

pub struct PackedItemUseLegacyInventoryTransaction {
pub mut:
	id               i32
	container_slots  []ContainerSlotEntry
	action           InventoryTransaction
	action_type      enums.ItemUseInventoryTransactionType
	trigger_type     TriggerType
	position         types_944.NetworkBlockPosition
	face             i32
	slot             i32
	item             types_662.NetworkItemStackDescriptor
	from_position    [3]f32
	click_position   [3]f32
	target_block_id  u32
	predicted_result PredictedResult
	cooldown_state   i8
}

pub fn (t PackedItemUseLegacyInventoryTransaction) encode(mut w serializer.Writer) {
	w.write_varint32(t.id)
	if t.id != 0 {
		w.write_varuint32(u32(t.container_slots.len))
		for e in t.container_slots {
			e.encode(mut w)
		}
	}
	t.action.encode(mut w)
	t.action_type.encode(mut w)
	t.trigger_type.encode(mut w)
	t.position.encode(mut w)
	w.write_varint32(t.face)
	w.write_varint32(t.slot)
	t.item.encode(mut w)
	w.le_f32(t.from_position[0])
	w.le_f32(t.from_position[1])
	w.le_f32(t.from_position[2])
	w.le_f32(t.click_position[0])
	w.le_f32(t.click_position[1])
	w.le_f32(t.click_position[2])
	w.write_varuint32(t.target_block_id)
	t.predicted_result.encode(mut w)
	w.i8(t.cooldown_state)
}

pub fn PackedItemUseLegacyInventoryTransaction.decode(mut r serializer.Reader) !PackedItemUseLegacyInventoryTransaction {
	mut t := PackedItemUseLegacyInventoryTransaction{}
	t.id = r.read_varint32()!
	if t.id != 0 {
		count := int(r.read_varuint32()!)
		t.container_slots = []ContainerSlotEntry{cap: count}
		for _ in 0 .. count {
			t.container_slots << ContainerSlotEntry.decode(mut r)!
		}
	}
	t.action = InventoryTransaction.decode(mut r)!
	t.action_type = enums.ItemUseInventoryTransactionType.decode(mut r)!
	t.trigger_type = TriggerType.decode(mut r)!
	t.position = types_944.NetworkBlockPosition.decode(mut r)!
	t.face = r.read_varint32()!
	t.slot = r.read_varint32()!
	t.item = types_662.NetworkItemStackDescriptor.decode(mut r)!
	t.from_position = [r.le_f32()!, r.le_f32()!, r.le_f32()!]!
	t.click_position = [r.le_f32()!, r.le_f32()!, r.le_f32()!]!
	t.target_block_id = r.read_varuint32()!
	t.predicted_result = PredictedResult.decode(mut r)!
	t.cooldown_state = r.i8()!
	return t
}
