module packets

import protocol.serializer

pub struct RequestNetworkSettingsPacket {
pub mut:
	client_network_version i32
}

pub fn (p &RequestNetworkSettingsPacket) pid() u16 {
	return 193
}

pub fn (p &RequestNetworkSettingsPacket) name() string {
	return 'RequestNetworkSettingsPacket'
}

pub fn (p &RequestNetworkSettingsPacket) can_be_sent_before_login() bool {
	return true
}

pub fn (p &RequestNetworkSettingsPacket) encode_payload(mut w serializer.Writer) {
	w.be_i32(p.client_network_version)
}

pub fn (mut p RequestNetworkSettingsPacket) decode_payload(mut r serializer.Reader) ! {
	p.client_network_version = r.be_i32()!
}
