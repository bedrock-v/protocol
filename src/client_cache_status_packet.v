module protocol

import serializer

pub struct ClientCacheStatusPacket {
pub mut:
	enabled bool
}

pub fn (p &ClientCacheStatusPacket) pid() u16 {
	return client_cache_status_packet
}

pub fn (p &ClientCacheStatusPacket) name() string {
	return 'ClientCacheStatusPacket'
}

pub fn (p &ClientCacheStatusPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p ClientCacheStatusPacket) decode_payload(mut r serializer.Reader) ! {
	p.enabled = r.bool()!
}

pub fn (p &ClientCacheStatusPacket) encode_payload(mut w serializer.Writer) {
	w.bool(p.enabled)
}
