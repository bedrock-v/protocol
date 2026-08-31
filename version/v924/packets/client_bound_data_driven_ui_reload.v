module packets

import protocol.serializer

pub struct ClientBoundDataDrivenUIReloadPacket {}

pub fn (p &ClientBoundDataDrivenUIReloadPacket) pid() u16 {
	return 335
}

pub fn (p &ClientBoundDataDrivenUIReloadPacket) name() string {
	return 'ClientBoundDataDrivenUIReloadPacket'
}

pub fn (p &ClientBoundDataDrivenUIReloadPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &ClientBoundDataDrivenUIReloadPacket) encode_payload(mut w serializer.Writer) {
}

pub fn (mut p ClientBoundDataDrivenUIReloadPacket) decode_payload(mut r serializer.Reader) ! {
}
