module packets

import protocol.serializer

pub struct TickSyncPacket {
pub mut:
	client_request_timestamp  i64
	server_response_timestamp i64
}

pub fn (p &TickSyncPacket) pid() u16 {
	return 23
}

pub fn (p &TickSyncPacket) name() string {
	return 'TickSyncPacket'
}

pub fn (p &TickSyncPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &TickSyncPacket) encode_payload(mut w serializer.Writer) {
	w.le_i64(p.client_request_timestamp)
	w.le_i64(p.server_response_timestamp)
}

pub fn (mut p TickSyncPacket) decode_payload(mut r serializer.Reader) ! {
	p.client_request_timestamp = r.le_i64()!
	p.server_response_timestamp = r.le_i64()!
}
