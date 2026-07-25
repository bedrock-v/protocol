module packets

import serializer

pub struct ClientStoreEntryPointConfiguration {
pub mut:
	store_id   string
	store_name string
}

pub fn (t ClientStoreEntryPointConfiguration) encode(mut w serializer.Writer) {
	w.write_string(t.store_id)
	w.write_string(t.store_name)
}

pub fn ClientStoreEntryPointConfiguration.decode(mut r serializer.Reader) !ClientStoreEntryPointConfiguration {
	return ClientStoreEntryPointConfiguration{
		store_id:   r.read_string()!
		store_name: r.read_string()!
	}
}

pub struct ServerStoreInfoPacket {
pub mut:
	client_store_entry_point_configuration ?ClientStoreEntryPointConfiguration
}

pub fn (p &ServerStoreInfoPacket) pid() u16 { return 346 }

pub fn (p &ServerStoreInfoPacket) name() string { return 'ServerStoreInfoPacket' }

pub fn (p &ServerStoreInfoPacket) can_be_sent_before_login() bool { return false }

pub fn (p &ServerStoreInfoPacket) encode_payload(mut w serializer.Writer) {
	if v := p.client_store_entry_point_configuration {
		w.bool(true)
		v.encode(mut w)
	} else {
		w.bool(false)
	}
}

pub fn (mut p ServerStoreInfoPacket) decode_payload(mut r serializer.Reader) ! {
	if r.bool()! {
		p.client_store_entry_point_configuration = ClientStoreEntryPointConfiguration.decode(mut r)!
	}
}
