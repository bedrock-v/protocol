module protocol

import serializer

pub struct SetTimePacket {
pub mut:
	time int
}

pub fn (p &SetTimePacket) pid() u16 {
	return set_time_packet
}

pub fn (p &SetTimePacket) name() string {
	return 'SetTimePacket'
}

pub fn (p &SetTimePacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p SetTimePacket) decode_payload(mut r serializer.Reader) ! {
	p.time = int(r.read_varint32()!)
}

pub fn (p &SetTimePacket) encode_payload(mut w serializer.Writer) {
	w.write_varint32(i32(p.time))
}
