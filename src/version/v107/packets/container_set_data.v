module packets

import protocol.serializer

pub struct ContainerSetDataPacket {
pub mut:
	windowid u8
	property i32
	value    i32
}

pub fn (p &ContainerSetDataPacket) pid() u16 {
	return 0x34
}

pub fn (p &ContainerSetDataPacket) name() string {
	return 'ContainerSetDataPacket'
}

pub fn (p &ContainerSetDataPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &ContainerSetDataPacket) encode_payload(mut w serializer.Writer) {
	w.u8(p.windowid)
	w.write_varint32(p.property)
	w.write_varint32(p.value)
}

pub fn (mut p ContainerSetDataPacket) decode_payload(mut r serializer.Reader) ! {
	p.windowid = r.u8()!
	p.property = r.read_varint32()!
	p.value = r.read_varint32()!
}
