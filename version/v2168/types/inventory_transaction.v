module types

import protocol.serializer
import protocol.version.v662.enums as enums_662
import protocol.version.v944.types as types_944

pub struct InventoryTransaction {
pub mut:
	action []InventoryAction
}

pub fn (t InventoryTransaction) encode(mut w serializer.Writer) {
	w.write_varuint32(u32(t.action.len))
	for e in t.action {
		e.encode(mut w)
	}
}

pub fn InventoryTransaction.decode(mut r serializer.Reader) !InventoryTransaction {
	count := r.read_count()!
	mut items := []InventoryAction{cap: serializer.prealloc(count)}
	for _ in 0 .. count {
		items << InventoryAction.decode(mut r)!
	}
	return InventoryTransaction{
		action: items
	}
}

pub struct NormalTransactionData {}

pub struct MismatchTransactionData {}

// UseItemTransactionData is sent when a player interacts with a block: place,
// use (right click in air) or destroy (break).
pub struct UseItemTransactionData {
pub mut:
	action_type      enums_662.ItemUseInventoryTransactionType
	trigger_type     TriggerType
	position         types_944.NetworkBlockPosition
	face             i32
	slot             i32
	item             NetworkItemStackDescriptor
	from_position    [3]f32
	click_position   [3]f32
	target_block_id  u32
	predicted_result PredictedResult
	cooldown_state   i8
}

pub fn (t UseItemTransactionData) encode(mut w serializer.Writer) {
	t.action_type.encode(mut w)
	t.trigger_type.encode(mut w)
	t.position.encode(mut w)
	w.u8(u8(t.face))
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

pub fn UseItemTransactionData.decode(mut r serializer.Reader) !UseItemTransactionData {
	return UseItemTransactionData{
		action_type:      enums_662.ItemUseInventoryTransactionType.decode(mut r)!
		trigger_type:     TriggerType.decode(mut r)!
		position:         types_944.NetworkBlockPosition.decode(mut r)!
		face:             i32(r.u8()!)
		slot:             r.read_varint32()!
		item:             NetworkItemStackDescriptor.decode(mut r)!
		from_position:    [r.le_f32()!, r.le_f32()!, r.le_f32()!]!
		click_position:   [r.le_f32()!, r.le_f32()!, r.le_f32()!]!
		target_block_id:  r.read_varuint32()!
		predicted_result: PredictedResult.decode(mut r)!
		cooldown_state:   r.i8()!
	}
}

// UseItemOnEntityTransactionData is sent when a player interacts with or
// attacks an entity.
pub struct UseItemOnEntityTransactionData {
pub mut:
	target_runtime_id u64
	action_type       enums_662.ItemUseOnActorInventoryTransactionType
	slot              i32
	item              NetworkItemStackDescriptor
	from_position     [3]f32
	click_position    [3]f32
}

pub fn (t UseItemOnEntityTransactionData) encode(mut w serializer.Writer) {
	w.write_varuint64(t.target_runtime_id)
	t.action_type.encode(mut w)
	w.write_varint32(t.slot)
	t.item.encode(mut w)
	w.le_f32(t.from_position[0])
	w.le_f32(t.from_position[1])
	w.le_f32(t.from_position[2])
	w.le_f32(t.click_position[0])
	w.le_f32(t.click_position[1])
	w.le_f32(t.click_position[2])
}

pub fn UseItemOnEntityTransactionData.decode(mut r serializer.Reader) !UseItemOnEntityTransactionData {
	return UseItemOnEntityTransactionData{
		target_runtime_id: r.read_varuint64()!
		action_type:       enums_662.ItemUseOnActorInventoryTransactionType.decode(mut r)!
		slot:              r.read_varint32()!
		item:              NetworkItemStackDescriptor.decode(mut r)!
		from_position:     [r.le_f32()!, r.le_f32()!, r.le_f32()!]!
		click_position:    [r.le_f32()!, r.le_f32()!, r.le_f32()!]!
	}
}

// ReleaseItemTransactionData is sent when a player releases a charging item
// (bow) or finishes eating/drinking.
pub struct ReleaseItemTransactionData {
pub mut:
	action_type   enums_662.ItemReleaseInventoryTransactionType
	slot          i32
	item          NetworkItemStackDescriptor
	head_position [3]f32
}

pub fn (t ReleaseItemTransactionData) encode(mut w serializer.Writer) {
	t.action_type.encode(mut w)
	w.write_varint32(t.slot)
	t.item.encode(mut w)
	w.le_f32(t.head_position[0])
	w.le_f32(t.head_position[1])
	w.le_f32(t.head_position[2])
}

pub fn ReleaseItemTransactionData.decode(mut r serializer.Reader) !ReleaseItemTransactionData {
	return ReleaseItemTransactionData{
		action_type:   enums_662.ItemReleaseInventoryTransactionType.decode(mut r)!
		slot:          r.read_varint32()!
		item:          NetworkItemStackDescriptor.decode(mut r)!
		head_position: [r.le_f32()!, r.le_f32()!, r.le_f32()!]!
	}
}

pub type InventoryTransactionData = MismatchTransactionData
	| NormalTransactionData
	| ReleaseItemTransactionData
	| UseItemOnEntityTransactionData
	| UseItemTransactionData
