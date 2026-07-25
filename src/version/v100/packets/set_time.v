module packets

import serializer

pub struct SetTimePacket {
pub mut:
	time    i32
	started bool
}

pub fn (p &SetTimePacket) pid() u16 {
	return 0x0b
}

pub fn (p &SetTimePacket) name() string {
	return 'SetTimePacket'
}

pub fn (p &SetTimePacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &SetTimePacket) encode_payload(mut w serializer.Writer) {
	w.write_varint32(p.time)
	w.u8(if p.started { u8(1) } else { u8(0) })
}

pub fn (mut p SetTimePacket) decode_payload(mut r serializer.Reader) ! {
	p.time = r.read_varint32()!
	p.started = r.u8()! > 0
}
