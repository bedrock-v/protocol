module types

import protocol.serializer

pub struct ItemStackResponseContainerInfo {
pub mut:
	container_net_id i8
	slots            []ItemStackResponseSlotInfo
}

pub fn (t ItemStackResponseContainerInfo) encode(mut w serializer.Writer) {
	w.i8(t.container_net_id)
	w.write_varuint32(u32(t.slots.len))
	for e in t.slots {
		e.encode(mut w)
	}
}

pub fn ItemStackResponseContainerInfo.decode(mut r serializer.Reader) !ItemStackResponseContainerInfo {
	id := r.i8()!
	count := r.read_count()!
	mut items := []ItemStackResponseSlotInfo{cap: serializer.prealloc(count)}
	for _ in 0 .. count {
		items << ItemStackResponseSlotInfo.decode(mut r)!
	}
	return ItemStackResponseContainerInfo{
		container_net_id: id
		slots:            items
	}
}
