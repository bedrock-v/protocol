module protocol

import serializer
import types

pub struct ContainerOpenPacket {
pub mut:
	window_id       int
	window_type     int
	block_position  types.BlockPosition
	actor_unique_id i64
}

pub fn (p &ContainerOpenPacket) pid() u16 {
	return container_open_packet
}

pub fn (p &ContainerOpenPacket) name() string {
	return 'ContainerOpenPacket'
}

pub fn (p &ContainerOpenPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p ContainerOpenPacket) decode_payload(mut r serializer.Reader) ! {
	p.window_id = int(r.u8()!)
	p.window_type = int(r.u8()!)
	p.block_position = r.read_block_position()!
	p.actor_unique_id = r.read_actor_unique_id()!
}

pub fn (p &ContainerOpenPacket) encode_payload(mut w serializer.Writer) {
	w.u8(u8(p.window_id))
	w.u8(u8(p.window_type))
	w.write_block_position(p.block_position)
	w.write_actor_unique_id(p.actor_unique_id)
}
