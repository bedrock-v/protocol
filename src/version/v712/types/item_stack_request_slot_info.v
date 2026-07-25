module types

import serializer

pub struct ItemStackRequestSlotInfo {
pub mut:
	container_name FullContainerName
	slot           i8
	raw_id         i32
}

pub fn (t ItemStackRequestSlotInfo) encode(mut w serializer.Writer) {
	t.container_name.encode(mut w)
	w.i8(t.slot)
	w.write_varint32(t.raw_id)
}

pub fn ItemStackRequestSlotInfo.decode(mut r serializer.Reader) !ItemStackRequestSlotInfo {
	return ItemStackRequestSlotInfo{
		container_name: FullContainerName.decode(mut r)!
		slot:           r.i8()!
		raw_id:         r.read_varint32()!
	}
}
