module packets

import serializer

pub struct InteractPacket {
pub mut:
	action i8
	eid    i32
	target i32
}

pub fn (p &InteractPacket) pid() u16 {
	return 0xa0
}

pub fn (p &InteractPacket) name() string {
	return 'InteractPacket'
}

pub fn (p &InteractPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &InteractPacket) encode_payload(mut w serializer.Writer) {
	w.i8(p.action)
	w.be_i32(p.eid)
	w.be_i32(p.target)
}

pub fn (mut p InteractPacket) decode_payload(mut r serializer.Reader) ! {
	p.action = r.i8()!
	p.eid = r.be_i32()!
	p.target = r.be_i32()!
}
