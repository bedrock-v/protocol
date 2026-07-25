module types

import serializer
import version.v944.types as types_944

pub struct ItemStackRequestSlotInfo {
pub mut:
	container_name types_944.FullContainerName
	slot           i8
	raw_id         i32
}

pub fn (t ItemStackRequestSlotInfo) encode(mut w serializer.Writer) {
	t.container_name.encode(mut w)
	w.i8(t.slot)
	w.le_i32(t.raw_id)
}

pub fn ItemStackRequestSlotInfo.decode(mut r serializer.Reader) !ItemStackRequestSlotInfo {
	return ItemStackRequestSlotInfo{
		container_name: types_944.FullContainerName.decode(mut r)!
		slot:           r.i8()!
		raw_id:         r.le_i32()!
	}
}
