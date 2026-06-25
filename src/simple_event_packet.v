module src

import src.serializer

pub struct SimpleEventPacket {
pub mut:
	event_type int
}

pub fn (p &SimpleEventPacket) pid() u16 {
	return simple_event_packet
}

pub fn (p &SimpleEventPacket) name() string {
	return 'SimpleEventPacket'
}

pub fn (p &SimpleEventPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p SimpleEventPacket) decode_payload(mut r serializer.Reader) ! {
	p.event_type = int(r.le_u16()!)
}

pub fn (p &SimpleEventPacket) encode_payload(mut w serializer.Writer) {
	w.le_u16(u16(p.event_type))
}
