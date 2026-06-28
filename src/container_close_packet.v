module protocol

import serializer

pub struct ContainerClosePacket {
pub mut:
	window_id   int
	window_type int
	server      bool
}

pub fn (p &ContainerClosePacket) pid() u16 {
	return container_close_packet
}

pub fn (p &ContainerClosePacket) name() string {
	return 'ContainerClosePacket'
}

pub fn (p &ContainerClosePacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p ContainerClosePacket) decode_payload(mut r serializer.Reader) ! {
	p.window_id = int(r.u8()!)
	p.window_type = int(r.u8()!)
	p.server = r.bool()!
}

pub fn (p &ContainerClosePacket) encode_payload(mut w serializer.Writer) {
	w.u8(u8(p.window_id))
	w.u8(u8(p.window_type))
	w.bool(p.server)
}
