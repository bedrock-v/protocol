module protocol

import serializer
import types

pub struct BlockEventPacket {
pub mut:
	block_position types.BlockPosition
	event_type     int
	event_data     int
}

pub fn (p &BlockEventPacket) pid() u16 {
	return block_event_packet
}

pub fn (p &BlockEventPacket) name() string {
	return 'BlockEventPacket'
}

pub fn (p &BlockEventPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p BlockEventPacket) decode_payload(mut r serializer.Reader) ! {
	p.block_position = r.read_block_position()!
	p.event_type = int(r.read_varint32()!)
	p.event_data = int(r.read_varint32()!)
}

pub fn (p &BlockEventPacket) encode_payload(mut w serializer.Writer) {
	w.write_block_position(p.block_position)
	w.write_varint32(i32(p.event_type))
	w.write_varint32(i32(p.event_data))
}
