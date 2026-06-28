module protocol

import serializer

pub struct RequestNetworkSettingsPacket {
pub mut:
	protocol_version int
}

pub fn (p &RequestNetworkSettingsPacket) pid() u16 {
	return request_network_settings_packet
}

pub fn (p &RequestNetworkSettingsPacket) name() string {
	return 'RequestNetworkSettingsPacket'
}

pub fn (p &RequestNetworkSettingsPacket) can_be_sent_before_login() bool {
	return true
}

pub fn (mut p RequestNetworkSettingsPacket) decode_payload(mut r serializer.Reader) ! {
	p.protocol_version = int(r.be_u32()!)
}

pub fn (p &RequestNetworkSettingsPacket) encode_payload(mut w serializer.Writer) {
	w.be_u32(u32(p.protocol_version))
}
