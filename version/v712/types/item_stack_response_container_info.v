module types

import protocol.serializer
import protocol.version.v662.types as types_662

pub struct ItemStackResponseContainerInfo {
pub mut:
	container_name FullContainerName
	slots          []types_662.ItemStackResponseSlotInfo
}

pub fn (t ItemStackResponseContainerInfo) encode(mut w serializer.Writer) {
	t.container_name.encode(mut w)
	w.write_varuint32(u32(t.slots.len))
	for e in t.slots {
		e.encode(mut w)
	}
}

pub fn ItemStackResponseContainerInfo.decode(mut r serializer.Reader) !ItemStackResponseContainerInfo {
	container_name := FullContainerName.decode(mut r)!
	count := r.read_count()!
	mut items := []types_662.ItemStackResponseSlotInfo{cap: serializer.prealloc(count)}
	for _ in 0 .. count {
		items << types_662.ItemStackResponseSlotInfo.decode(mut r)!
	}
	return ItemStackResponseContainerInfo{
		container_name: container_name
		slots:          items
	}
}
