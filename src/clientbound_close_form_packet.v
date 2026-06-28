module protocol

import serializer

pub struct ClientboundCloseFormPacket {
}

pub fn (p &ClientboundCloseFormPacket) pid() u16 {
	return clientbound_close_form_packet
}

pub fn (p &ClientboundCloseFormPacket) name() string {
	return 'ClientboundCloseFormPacket'
}

pub fn (p &ClientboundCloseFormPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p ClientboundCloseFormPacket) decode_payload(mut r serializer.Reader) ! {
}

pub fn (p &ClientboundCloseFormPacket) encode_payload(mut w serializer.Writer) {
}
