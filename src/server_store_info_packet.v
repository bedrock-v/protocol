module src

import src.serializer

pub struct ClientStoreEntrypointConfig {
pub mut:
	store_id   string
	store_name string
}

pub struct ServerStoreInfoPacket {
pub mut:
	config ?ClientStoreEntrypointConfig
}

pub fn (p &ServerStoreInfoPacket) pid() u16 {
	return server_store_info_packet
}

pub fn (p &ServerStoreInfoPacket) name() string {
	return 'ServerStoreInfoPacket'
}

pub fn (p &ServerStoreInfoPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p ServerStoreInfoPacket) decode_payload(mut r serializer.Reader) ! {
	if r.bool()! {
		p.config = ClientStoreEntrypointConfig{
			store_id:   r.read_string()!
			store_name: r.read_string()!
		}
	}
}

pub fn (p &ServerStoreInfoPacket) encode_payload(mut w serializer.Writer) {
	if c := p.config {
		w.bool(true)
		w.write_string(c.store_id)
		w.write_string(c.store_name)
	} else {
		w.bool(false)
	}
}
