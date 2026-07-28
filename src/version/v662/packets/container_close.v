module packets

import protocol.serializer
import protocol.version.v662.enums

pub struct ContainerClosePacket {
pub mut:
	container_id           enums.ContainerID
	server_initiated_close bool
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
	p.container_id.encode(mut w)
	w.bool(p.server_initiated_close)
}

pub fn (mut p ContainerClosePacket) decode_payload(mut r serializer.Reader) ! {
	p.container_id = enums.ContainerID.decode(mut r)!
	p.server_initiated_close = r.bool()!
}
