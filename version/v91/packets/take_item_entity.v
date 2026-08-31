module packets

import protocol.serializer

pub struct TakeItemEntityPacket {
pub mut:
	target i32
	eid    i32
}

pub fn (p &TakeItemEntityPacket) pid() u16 {
	return 0x12
}

pub fn (p &TakeItemEntityPacket) name() string {
	return 'TakeItemEntityPacket'
}

pub fn (p &TakeItemEntityPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &TakeItemEntityPacket) encode_payload(mut w serializer.Writer) {
	w.write_varint32(p.target)
	w.write_varint32(p.eid)
}

pub fn (mut p TakeItemEntityPacket) decode_payload(mut r serializer.Reader) ! {
	p.target = r.read_varint32()!
	p.eid = r.read_varint32()!
}
