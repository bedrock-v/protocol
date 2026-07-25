module packets

import serializer

pub struct SetHealthPacket {
pub mut:
	health i32
}

pub fn (p &SetHealthPacket) pid() u16 {
	return 0x2a
}

pub fn (p &SetHealthPacket) name() string {
	return 'SetHealthPacket'
}

pub fn (p &SetHealthPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &SetHealthPacket) encode_payload(mut w serializer.Writer) {
	w.write_varint32(p.health)
}

pub fn (mut p SetHealthPacket) decode_payload(mut r serializer.Reader) ! {
	p.health = r.read_varint32()!
}
