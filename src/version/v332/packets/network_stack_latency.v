module packets

import serializer

pub struct NetworkStackLatencyPacket {
pub mut:
	timestamp   i64
	from_server bool
}

pub fn (p &NetworkStackLatencyPacket) pid() u16 {
	return 115
}

pub fn (p &NetworkStackLatencyPacket) name() string {
	return 'NetworkStackLatencyPacket'
}

pub fn (p &NetworkStackLatencyPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &NetworkStackLatencyPacket) encode_payload(mut w serializer.Writer) {
	w.le_i64(p.timestamp)
	w.bool(p.from_server)
}

pub fn (mut p NetworkStackLatencyPacket) decode_payload(mut r serializer.Reader) ! {
	p.timestamp = r.le_i64()!
	p.from_server = r.bool()!
}
