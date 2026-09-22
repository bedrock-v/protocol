module packets

import protocol.serializer

pub struct NetworkStackLatencyPacket {
pub mut:
	creation_time  u64
	is_from_server bool
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
	w.le_u64(p.creation_time)
	w.bool(p.is_from_server)
}

pub fn (mut p NetworkStackLatencyPacket) decode_payload(mut r serializer.Reader) ! {
	p.creation_time = r.le_u64()!
	p.is_from_server = r.bool()!
}
