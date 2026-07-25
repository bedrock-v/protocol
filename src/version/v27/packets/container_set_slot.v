module packets

import serializer
import version.v14.types

pub struct ContainerSetSlotPacket {
pub mut:
	windowid u8
	slot     i16
	item     types.OldItem
}

pub fn (p &ContainerSetSlotPacket) pid() u16 {
	return 0xa8
}

pub fn (p &ContainerSetSlotPacket) name() string {
	return 'ContainerSetSlotPacket'
}

pub fn (p &ContainerSetSlotPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &ContainerSetSlotPacket) encode_payload(mut w serializer.Writer) {
	w.u8(p.windowid)
	w.be_i16(p.slot)
	p.item.encode(mut w)
}

pub fn (mut p ContainerSetSlotPacket) decode_payload(mut r serializer.Reader) ! {
	p.windowid = r.u8()!
	p.slot = r.be_i16()!
	p.item = types.OldItem.decode(mut r)!
}
