module packets

import serializer

pub struct ContainerClosePacket {
pub mut:
	id               i8
	server_initiated bool
}

pub fn (p &ContainerClosePacket) pid() u16 {
	return 47
}

pub fn (p &ContainerClosePacket) name() string {
	return 'ContainerClosePacket'
}

pub fn (p &ContainerClosePacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &ContainerClosePacket) encode_payload(mut w serializer.Writer) {
	w.i8(p.id)
	w.bool(p.server_initiated)
}

pub fn (mut p ContainerClosePacket) decode_payload(mut r serializer.Reader) ! {
	p.id = r.i8()!
	p.server_initiated = r.bool()!
}
