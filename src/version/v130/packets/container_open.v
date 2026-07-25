module packets

import serializer
import version.v137.types

pub struct ContainerOpenPacket {
pub mut:
	window_id        u8
	window_type      u8
	position         types.BlockPosition
	entity_unique_id i64
}

pub fn (p &ContainerOpenPacket) pid() u16 {
	return 46
}

pub fn (p &ContainerOpenPacket) name() string {
	return 'ContainerOpenPacket'
}

pub fn (p &ContainerOpenPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &ContainerOpenPacket) encode_payload(mut w serializer.Writer) {
	w.u8(p.window_id)
	w.u8(p.window_type)
	p.position.encode(mut w)
	w.write_varint64(p.entity_unique_id)
}

pub fn (mut p ContainerOpenPacket) decode_payload(mut r serializer.Reader) ! {
	p.window_id = r.u8()!
	p.window_type = r.u8()!
	p.position = types.BlockPosition.decode(mut r)!
	p.entity_unique_id = r.read_varint64()!
}
