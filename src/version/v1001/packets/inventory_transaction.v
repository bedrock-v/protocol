module packets

import protocol.serializer
import protocol.version.v662.enums
import protocol.version.v1001.types

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
	legacy_set_item_slots []LegacySetItemSlotsEntry
	transaction_type      enums.ComplexInventoryTransactionType
	transaction           types.InventoryTransaction
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
	has_legacy := p.raw_id < -1 && (p.raw_id & 1) == 0
	w.bool(has_legacy)
	if has_legacy {
		w.write_varuint32(u32(p.legacy_set_item_slots.len))
		for e in p.legacy_set_item_slots {
			e.encode(mut w)
		}
	}
	w.bool(true)
	p.transaction_type.encode(mut w)
	w.bool(true)
	p.transaction.encode(mut w)
}

pub fn (mut p InventoryTransactionPacket) decode_payload(mut r serializer.Reader) ! {
	p.raw_id = r.read_varint32()!
	if r.bool()! {
		count := int(r.read_varuint32()!)
		mut items := []LegacySetItemSlotsEntry{cap: count}
		for _ in 0 .. count {
			items << LegacySetItemSlotsEntry.decode(mut r)!
		}
		p.legacy_set_item_slots = items
	}
	if r.bool()! {
		p.transaction_type = enums.ComplexInventoryTransactionType.decode(mut r)!
	}
	if r.bool()! {
		p.transaction = types.InventoryTransaction.decode(u32(p.transaction_type), mut r)!
	}
}
