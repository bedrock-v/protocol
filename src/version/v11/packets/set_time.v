module packets

import serializer

pub struct SetTimePacket {
pub mut:
	time i64
}

pub fn (p &SetTimePacket) pid() u16 {
	return 0x86
}

pub fn (p &SetTimePacket) name() string {
	return 'SetTimePacket'
}

pub fn (p &SetTimePacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &SetTimePacket) encode_payload(mut w serializer.Writer) {
	w.be_i64(p.time)
}

pub fn (mut p SetTimePacket) decode_payload(mut r serializer.Reader) ! {
	p.time = i64(r.be_u32()!)
}
