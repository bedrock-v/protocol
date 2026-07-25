module types

import serializer
import version.v662.enums

pub struct ItemStackRequestSlotInfo {
pub mut:
	container_net_id enums.ContainerEnumName
	slot             i8
	raw_id           i32
}

pub fn (t ItemStackRequestSlotInfo) encode(mut w serializer.Writer) {
	t.container_net_id.encode(mut w)
	w.i8(t.slot)
	w.write_varint32(t.raw_id)
}

pub fn ItemStackRequestSlotInfo.decode(mut r serializer.Reader) !ItemStackRequestSlotInfo {
	return ItemStackRequestSlotInfo{
		container_net_id: enums.ContainerEnumName.decode(mut r)!
		slot:             r.i8()!
		raw_id:           r.read_varint32()!
	}
}
