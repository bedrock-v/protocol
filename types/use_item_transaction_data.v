module types

import protocol.serializer
import protocol.enums

// UseItemTransactionData is what an InventoryTransactionPacket carries after
// its actions when the transaction is an item use: the click that placed,
// broke or used a block.
//
// It is the same body PlayerAuthInputPacket packs into its own item use
// transaction, without the legacy request id and slot list that wrap it there.
pub struct UseItemTransactionData {
pub mut:
	action_type      enums.ItemUseInventoryTransactionType
	trigger_type     TriggerType
	position         NetworkBlockPosition
	face             u8
	slot             i32
	hand_slot        HandSlot
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
	w.u8(t.face)
	w.write_varint32(t.slot)
	t.hand_slot.encode(mut w)
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
	mut t := UseItemTransactionData{}
	t.action_type = enums.ItemUseInventoryTransactionType.decode(mut r)!
	t.trigger_type = TriggerType.decode(mut r)!
	t.position = NetworkBlockPosition.decode(mut r)!
	t.face = r.u8()!
	t.slot = r.read_varint32()!
	t.hand_slot = HandSlot.decode(mut r)!
	t.item = NetworkItemStackDescriptor.decode(mut r)!
	t.from_position = [r.le_f32()!, r.le_f32()!, r.le_f32()!]!
	t.click_position = [r.le_f32()!, r.le_f32()!, r.le_f32()!]!
	t.target_block_id = r.read_varuint32()!
	t.predicted_result = PredictedResult.decode(mut r)!
	t.cooldown_state = r.i8()!
	return t
}
