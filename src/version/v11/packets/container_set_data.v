module packets

import protocol.serializer

pub struct ContainerSetDataPacket {
pub mut:
	windowid u8
	property i16
	value    i16
}

pub fn (p &ContainerSetDataPacket) pid() u16 {
	return 0xb2
}

pub fn (p &ContainerSetDataPacket) name() string {
	return 'ContainerSetDataPacket'
}

pub fn (p &ContainerSetDataPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &ContainerSetDataPacket) encode_payload(mut w serializer.Writer) {
	w.u8(p.windowid)
	w.be_i16(p.property)
	w.be_i16(p.value)
}

pub fn (mut p ContainerSetDataPacket) decode_payload(mut r serializer.Reader) ! {
	p.windowid = r.u8()!
	p.property = r.be_i16()!
	p.value = r.be_i16()!
}
