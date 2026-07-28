module packets

import protocol.serializer

pub struct ClientBoundCloseFormPacket {}

pub fn (p &ClientBoundCloseFormPacket) pid() u16 {
	return 310
}

pub fn (p &ClientBoundCloseFormPacket) name() string {
	return 'ClientBoundCloseFormPacket'
}

pub fn (p &ClientBoundCloseFormPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &ClientBoundCloseFormPacket) encode_payload(mut w serializer.Writer) {
}

pub fn (mut p ClientBoundCloseFormPacket) decode_payload(mut r serializer.Reader) ! {
}
