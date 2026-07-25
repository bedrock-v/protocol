module packets

import serializer

pub struct BlockEventPacket {
pub mut:
	x     i32
	y     i32
	z     i32
	case1 i32
	case2 i32
}

pub fn (p &BlockEventPacket) pid() u16 {
	return 0xa3
}

pub fn (p &BlockEventPacket) name() string {
	return 'BlockEventPacket'
}

pub fn (p &BlockEventPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &BlockEventPacket) encode_payload(mut w serializer.Writer) {
	w.be_i32(p.x)
	w.be_i32(p.y)
	w.be_i32(p.z)
	w.be_i32(p.case1)
	w.be_i32(p.case2)
}

pub fn (mut p BlockEventPacket) decode_payload(mut r serializer.Reader) ! {
	p.x = r.be_i32()!
	p.y = r.be_i32()!
	p.z = r.be_i32()!
	p.case1 = r.be_i32()!
	p.case2 = r.be_i32()!
}
