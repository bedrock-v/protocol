module packets

import protocol.serializer
import protocol.version.v2168.types as types_2168
import protocol.version.v2192.types
import protocol.version.v662.enums as enums_662

pub struct LegacySetItemSlotsEntry {
pub mut:
	container_enum i8
	slot_vector    []i8
}

pub fn (e LegacySetItemSlotsEntry) encode(mut w serializer.Writer) {
	w.i8(e.container_enum)
	w.write_varuint32(u32(e.slot_vector.len))
	for s in e.slot_vector {
		w.i8(s)
	}
}

pub fn LegacySetItemSlotsEntry.decode(mut r serializer.Reader) !LegacySetItemSlotsEntry {
	container_enum := r.i8()!
	count := int(r.read_varuint32()!)
	mut slots := []i8{cap: count}
	for _ in 0 .. count {
		slots << r.i8()!
	}
	return LegacySetItemSlotsEntry{
		container_enum: container_enum
		slot_vector:    slots
	}
}

pub struct InventoryTransactionPacket {
pub mut:
	raw_id                i32
	legacy_set_item_slots ?[]LegacySetItemSlotsEntry
	transaction_type      enums_662.ComplexInventoryTransactionType
	transaction           types_2168.InventoryTransaction
	// use_item is present only for an item use transaction. The other complex
	// types carry their own bodies, which nothing reads yet and which are left
	// on the wire rather than guessed at.
	use_item ?types.UseItemTransactionData
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
	w.write_varint32(p.raw_id)
	if slots := p.legacy_set_item_slots {
		w.bool(true)
		w.write_varuint32(u32(slots.len))
		for e in slots {
			e.encode(mut w)
		}
	} else {
		w.bool(false)
	}
	p.transaction_type.encode(mut w)
	p.transaction.encode(mut w)
	if v := p.use_item {
		v.encode(mut w)
	}
}

pub fn (mut p InventoryTransactionPacket) decode_payload(mut r serializer.Reader) ! {
	p.raw_id = r.read_varint32()!
	if r.bool()! {
		count := int(r.read_varuint32()!)
		mut slots := []LegacySetItemSlotsEntry{cap: count}
		for _ in 0 .. count {
			slots << LegacySetItemSlotsEntry.decode(mut r)!
		}
		p.legacy_set_item_slots = slots
	}
	p.transaction_type = enums_662.ComplexInventoryTransactionType.decode(mut r)!
	p.transaction = types_2168.InventoryTransaction.decode(mut r)!
	if p.transaction_type == .item_use_transaction {
		p.use_item = types.UseItemTransactionData.decode(mut r)!
	} else {
		p.use_item = none
	}
}
