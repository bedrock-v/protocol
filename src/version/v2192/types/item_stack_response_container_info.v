module types

import protocol.serializer
import protocol.version.v944.types as types_944

pub struct ItemStackResponseContainerInfo {
pub mut:
	container_name types_944.FullContainerName
	slots          []ItemStackResponseSlotInfo
}

pub fn (t ItemStackResponseContainerInfo) encode(mut w serializer.Writer) {
	t.container_name.encode(mut w)
	w.write_varuint32(u32(t.slots.len))
	for e in t.slots {
		e.encode(mut w)
	}
}

pub fn ItemStackResponseContainerInfo.decode(mut r serializer.Reader) !ItemStackResponseContainerInfo {
	mut t := ItemStackResponseContainerInfo{}
	t.container_name = types_944.FullContainerName.decode(mut r)!
	count := int(r.read_varuint32()!)
	t.slots = []ItemStackResponseSlotInfo{cap: count}
	for _ in 0 .. count {
		t.slots << ItemStackResponseSlotInfo.decode(mut r)!
	}
	return t
}
