module packets

import protocol.serializer

pub struct AnimatePacket {
pub mut:
	action i32
	eid    i32
}

pub fn (p &AnimatePacket) pid() u16 {
	return 0x2c
}

pub fn (p &AnimatePacket) name() string {
	return 'AnimatePacket'
}

pub fn (p &AnimatePacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &AnimatePacket) encode_payload(mut w serializer.Writer) {
	w.write_varint32(p.action)
	w.write_varint32(p.eid)
}

pub fn (mut p AnimatePacket) decode_payload(mut r serializer.Reader) ! {
	p.action = r.read_varint32()!
	p.eid = r.read_varint32()!
}
