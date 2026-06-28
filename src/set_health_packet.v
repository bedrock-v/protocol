module protocol

import serializer

pub struct SetHealthPacket {
pub mut:
	health int
}

pub fn (p &SetHealthPacket) pid() u16 {
	return set_health_packet
}

pub fn (p &SetHealthPacket) name() string {
	return 'SetHealthPacket'
}

pub fn (p &SetHealthPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p SetHealthPacket) decode_payload(mut r serializer.Reader) ! {
	p.health = int(r.read_varint32()!)
}

pub fn (p &SetHealthPacket) encode_payload(mut w serializer.Writer) {
	w.write_varint32(i32(p.health))
}
