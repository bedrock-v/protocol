module packets

import serializer

pub struct TakeItemEntityPacket {
pub mut:
	target i64
	eid    i64
}

pub fn (p &TakeItemEntityPacket) pid() u16 {
	return 0x9b
}

pub fn (p &TakeItemEntityPacket) name() string {
	return 'TakeItemEntityPacket'
}

pub fn (p &TakeItemEntityPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &TakeItemEntityPacket) encode_payload(mut w serializer.Writer) {
	w.be_i64(p.target)
	w.be_i64(p.eid)
}

pub fn (mut p TakeItemEntityPacket) decode_payload(mut r serializer.Reader) ! {
	p.target = r.be_i64()!
	p.eid = r.be_i64()!
}
