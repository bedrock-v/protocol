module packets

import protocol.serializer
import protocol.version.v944.types

pub struct BlockEventPacket {
pub mut:
	block_position types.NetworkBlockPosition
	event_type     i32
	event_value    i32
}

pub fn (p &BlockEventPacket) pid() u16 {
	return 26
}

pub fn (p &BlockEventPacket) name() string {
	return 'BlockEventPacket'
}

pub fn (p &BlockEventPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &BlockEventPacket) encode_payload(mut w serializer.Writer) {
	p.block_position.encode(mut w)
	w.write_varint32(p.event_type)
	w.write_varint32(p.event_value)
}

pub fn (mut p BlockEventPacket) decode_payload(mut r serializer.Reader) ! {
	p.block_position = types.NetworkBlockPosition.decode(mut r)!
	p.event_type = r.read_varint32()!
	p.event_value = r.read_varint32()!
}
