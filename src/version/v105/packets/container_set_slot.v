module packets

import serializer
import version.v105.types

pub struct ContainerSetSlotPacket {
pub mut:
	windowid    u8
	slot        i32
	hotbar_slot i32
	item        types.EraBItem
	unknown     u8
}

pub fn (p &ContainerSetSlotPacket) pid() u16 {
	return 0x33
}

pub fn (p &ContainerSetSlotPacket) name() string {
	return 'ContainerSetSlotPacket'
}

pub fn (p &ContainerSetSlotPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &ContainerSetSlotPacket) encode_payload(mut w serializer.Writer) {
	w.u8(p.windowid)
	w.write_varint32(p.slot)
	w.write_varint32(p.hotbar_slot)
	p.item.encode(mut w)
	w.u8(p.unknown)
}

pub fn (mut p ContainerSetSlotPacket) decode_payload(mut r serializer.Reader) ! {
	p.windowid = r.u8()!
	p.slot = r.read_varint32()!
	p.hotbar_slot = r.read_varint32()!
	p.item = types.EraBItem.decode(mut r)!
	p.unknown = r.u8()!
}
