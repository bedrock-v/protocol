module types

import protocol.serializer
import protocol.version.v944.types as types_944
import protocol.version.v975.types as types_975

pub struct NormalTransactionData {}

pub struct MismatchTransactionData {}

pub struct UseItemTransactionData {
pub mut:
	action_type      i32
	trigger_type     u32
	position         types_944.NetworkBlockPosition
	face             i32
	slot             i32
	item             types_975.NetworkItemStackDescriptorV2
	from_position    [3]f32
	click_position   [3]f32
	block_runtime_id u32
	predicted_result u8
	cooldown_state   u8
}

pub struct UseItemOnEntityTransactionData {
pub mut:
	target_runtime_id u64
	action_type       i32
	slot              i32
	item              types_975.NetworkItemStackDescriptorV2
	from_position     [3]f32
	click_position    [3]f32
}

pub struct ReleaseItemTransactionData {
pub mut:
	action_type   i32
	slot          i32
	item          types_975.NetworkItemStackDescriptorV2
	head_position [3]f32
}

pub type InventoryTransactionData = MismatchTransactionData
	| NormalTransactionData
	| ReleaseItemTransactionData
	| UseItemOnEntityTransactionData
	| UseItemTransactionData

pub fn (t InventoryTransactionData) encode(mut w serializer.Writer) {
	match t {
		NormalTransactionData, MismatchTransactionData {}
		UseItemTransactionData {
			w.write_varint32(t.action_type)
			w.u8(u8(t.trigger_type))
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
			w.write_varuint32(t.block_runtime_id)
			w.u8(t.predicted_result)
			w.u8(t.cooldown_state)
		}
		UseItemOnEntityTransactionData {
			w.write_varuint64(t.target_runtime_id)
			w.write_varint32(t.action_type)
			w.write_varint32(t.slot)
			t.item.encode(mut w)
			w.le_f32(t.from_position[0])
			w.le_f32(t.from_position[1])
			w.le_f32(t.from_position[2])
			w.le_f32(t.click_position[0])
			w.le_f32(t.click_position[1])
			w.le_f32(t.click_position[2])
		}
		ReleaseItemTransactionData {
			w.write_varint32(t.action_type)
			w.write_varint32(t.slot)
			t.item.encode(mut w)
			w.le_f32(t.head_position[0])
			w.le_f32(t.head_position[1])
			w.le_f32(t.head_position[2])
		}
	}
}

pub fn InventoryTransactionData.decode(transaction_type u32, mut r serializer.Reader) !InventoryTransactionData {
	match transaction_type {
		0 {
			return NormalTransactionData{}
		}
		1 {
			return MismatchTransactionData{}
		}
		2 {
			return UseItemTransactionData{
				action_type:      r.read_varint32()!
				trigger_type:     u32(r.u8()!)
				position:         types_944.NetworkBlockPosition.decode(mut r)!
				face:             i32(r.u8()!)
				slot:             r.read_varint32()!
				item:             types_975.NetworkItemStackDescriptorV2.decode(mut r)!
				from_position:    [r.le_f32()!, r.le_f32()!, r.le_f32()!]!
				click_position:   [r.le_f32()!, r.le_f32()!, r.le_f32()!]!
				block_runtime_id: r.read_varuint32()!
				predicted_result: r.u8()!
				cooldown_state:   r.u8()!
			}
		}
		3 {
			return UseItemOnEntityTransactionData{
				target_runtime_id: r.read_varuint64()!
				action_type:       r.read_varint32()!
				slot:              r.read_varint32()!
				item:              types_975.NetworkItemStackDescriptorV2.decode(mut r)!
				from_position:     [r.le_f32()!, r.le_f32()!,
					r.le_f32()!]!
				click_position:    [r.le_f32()!, r.le_f32()!,
					r.le_f32()!]!
			}
		}
		4 {
			return ReleaseItemTransactionData{
				action_type:   r.read_varint32()!
				slot:          r.read_varint32()!
				item:          types_975.NetworkItemStackDescriptorV2.decode(mut r)!
				head_position: [r.le_f32()!, r.le_f32()!, r.le_f32()!]!
			}
		}
		else {
			return error('invalid InventoryTransactionData ${transaction_type}')
		}
	}
}

pub struct InventoryTransaction {
pub mut:
	action []InventoryAction
	data   InventoryTransactionData = NormalTransactionData{}
}

pub fn (t InventoryTransaction) encode(mut w serializer.Writer) {
	w.write_varuint32(u32(t.action.len))
	for e in t.action {
		e.encode(mut w)
	}
	t.data.encode(mut w)
}

pub fn InventoryTransaction.decode(transaction_type u32, mut r serializer.Reader) !InventoryTransaction {
	count := int(r.read_varuint32()!)
	mut items := []InventoryAction{cap: count}
	for _ in 0 .. count {
		items << InventoryAction.decode(mut r)!
	}
	return InventoryTransaction{
		action: items
		data:   InventoryTransactionData.decode(transaction_type, mut r)!
	}
}

pub struct LegacyInventoryTransaction {
pub mut:
	action []LegacyInventoryAction
}

pub fn (t LegacyInventoryTransaction) encode(mut w serializer.Writer) {
	w.write_varuint32(u32(t.action.len))
	for e in t.action {
		e.encode(mut w)
	}
}

pub fn LegacyInventoryTransaction.decode(mut r serializer.Reader) !LegacyInventoryTransaction {
	count := int(r.read_varuint32()!)
	mut items := []LegacyInventoryAction{cap: count}
	for _ in 0 .. count {
		items << LegacyInventoryAction.decode(mut r)!
	}
	return LegacyInventoryTransaction{
		action: items
	}
}
