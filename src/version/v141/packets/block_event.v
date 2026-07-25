module packets

import serializer
import version.v137.types

pub struct BlockEventPacket {
pub mut:
	position   types.BlockPosition
	event_type i32
	event_data i32
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
	p.position.encode(mut w)
	w.write_varint32(p.event_type)
	w.write_varint32(p.event_data)
}

pub fn (mut p BlockEventPacket) decode_payload(mut r serializer.Reader) ! {
	p.position = types.BlockPosition.decode(mut r)!
	p.event_type = r.read_varint32()!
	p.event_data = r.read_varint32()!
}
