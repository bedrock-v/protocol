module packets

import protocol.serializer

pub struct ClientCacheStatusPacket {
pub mut:
	supported bool
}

pub fn (p &ClientCacheStatusPacket) pid() u16 {
	return 129
}

pub fn (p &ClientCacheStatusPacket) name() string {
	return 'ClientCacheStatusPacket'
}

pub fn (p &ClientCacheStatusPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &ClientCacheStatusPacket) encode_payload(mut w serializer.Writer) {
	w.bool(p.supported)
}

pub fn (mut p ClientCacheStatusPacket) decode_payload(mut r serializer.Reader) ! {
	p.supported = r.bool()!
}
