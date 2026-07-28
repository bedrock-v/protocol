module types

import protocol.serializer
import protocol.version.v766.types as types_766

pub struct ItemStackResponseContainerInfo {
pub mut:
	container_name FullContainerName
	slots          []types_766.ItemStackResponseSlotInfo
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
	count := int(r.read_varuint32()!)
	mut items := []types_766.ItemStackResponseSlotInfo{cap: count}
	for _ in 0 .. count {
		items << types_766.ItemStackResponseSlotInfo.decode(mut r)!
	}
	return ItemStackResponseContainerInfo{
		container_name: container_name
		slots:          items
	}
}
