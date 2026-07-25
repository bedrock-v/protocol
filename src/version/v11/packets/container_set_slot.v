module packets

import serializer

pub struct ContainerSetSlotPacket {
pub mut:
	windowid u8
	slot     u16
	block    u16
	stack    u8
	meta     u16
}

pub fn (p &ContainerSetSlotPacket) pid() u16 {
	return 0xb1
}

pub fn (p &ContainerSetSlotPacket) name() string {
	return 'ContainerSetSlotPacket'
}

pub fn (p &ContainerSetSlotPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &ContainerSetSlotPacket) encode_payload(mut w serializer.Writer) {
	w.u8(p.windowid)
	w.be_u16(p.slot)
	w.be_u16(p.block)
	w.u8(p.stack)
	w.be_u16(p.meta)
}

pub fn (mut p ContainerSetSlotPacket) decode_payload(mut r serializer.Reader) ! {
	p.windowid = r.u8()!
	p.slot = r.be_u16()!
	p.block = r.be_u16()!
	p.stack = r.u8()!
	p.meta = r.be_u16()!
}
