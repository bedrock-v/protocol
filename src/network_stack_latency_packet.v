module src

import src.serializer

pub struct NetworkStackLatencyPacket {
pub mut:
	timestamp     u64
	need_response bool
}

pub fn (p &NetworkStackLatencyPacket) pid() u16 {
	return network_stack_latency_packet
}

pub fn (p &NetworkStackLatencyPacket) name() string {
	return 'NetworkStackLatencyPacket'
}

pub fn (p &NetworkStackLatencyPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p NetworkStackLatencyPacket) decode_payload(mut r serializer.Reader) ! {
	p.timestamp = r.le_u64()!
	p.need_response = r.bool()!
}

pub fn (p &NetworkStackLatencyPacket) encode_payload(mut w serializer.Writer) {
	w.le_u64(p.timestamp)
	w.bool(p.need_response)
}
