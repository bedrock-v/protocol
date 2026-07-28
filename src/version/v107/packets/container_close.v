module packets

import protocol.serializer

pub struct ContainerClosePacket {
pub mut:
	windowid u8
}

pub fn (p &ContainerClosePacket) pid() u16 {
	return 0x32
}

pub fn (p &ContainerClosePacket) name() string {
	return 'ContainerClosePacket'
}

pub fn (p &ContainerClosePacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &ContainerClosePacket) encode_payload(mut w serializer.Writer) {
	w.u8(p.windowid)
}

pub fn (mut p ContainerClosePacket) decode_payload(mut r serializer.Reader) ! {
	p.windowid = r.u8()!
}
