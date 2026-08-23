module types

import protocol.serializer
import protocol.version.v662.enums

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
	count := r.read_count()!
	mut slots := []i8{cap: serializer.prealloc(count)}
	for _ in 0 .. count {
		slots << r.i8()!
	}
	return ContainerSlotEntry{
		container_enum_name: name
		slots:               slots
	}
}

pub struct PackedItemUseLegacyInventoryTransaction {
pub mut:
	id               i32
	container_slots  []ContainerSlotEntry
	action           InventoryTransaction
	action_type      enums.ItemUseInventoryTransactionType
	position         NetworkBlockPosition
	face             i32
	slot             i32
	item             NetworkItemStackDescriptor
	from_position_x  f32
	from_position_y  f32
	from_position_z  f32
	click_position_x f32
	click_position_y f32
	click_position_z f32
	target_block_id  u32
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
	t.position.encode(mut w)
	w.write_varint32(t.face)
	w.write_varint32(t.slot)
	t.item.encode(mut w)
	w.le_f32(t.from_position_x)
	w.le_f32(t.from_position_y)
	w.le_f32(t.from_position_z)
	w.le_f32(t.click_position_x)
	w.le_f32(t.click_position_y)
	w.le_f32(t.click_position_z)
	w.write_varuint32(t.target_block_id)
}

pub fn PackedItemUseLegacyInventoryTransaction.decode(mut r serializer.Reader) !PackedItemUseLegacyInventoryTransaction {
	mut t := PackedItemUseLegacyInventoryTransaction{}
	t.id = r.read_varint32()!
	if t.id != 0 {
		count := r.read_count()!
		t.container_slots = []ContainerSlotEntry{cap: serializer.prealloc(count)}
		for _ in 0 .. count {
			t.container_slots << ContainerSlotEntry.decode(mut r)!
		}
	}
	t.action = InventoryTransaction.decode(mut r)!
	t.action_type = enums.ItemUseInventoryTransactionType.decode(mut r)!
	t.position = NetworkBlockPosition.decode(mut r)!
	t.face = r.read_varint32()!
	t.slot = r.read_varint32()!
	t.item = NetworkItemStackDescriptor.decode(mut r)!
	t.from_position_x = r.le_f32()!
	t.from_position_y = r.le_f32()!
	t.from_position_z = r.le_f32()!
	t.click_position_x = r.le_f32()!
	t.click_position_y = r.le_f32()!
	t.click_position_z = r.le_f32()!
	t.target_block_id = r.read_varuint32()!
	return t
}
