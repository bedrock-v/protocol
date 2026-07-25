module packets

import serializer

pub struct ClientBoundDataDrivenUICloseAllScreensPacket {}

pub fn (p &ClientBoundDataDrivenUICloseAllScreensPacket) pid() u16 {
	return 334
}

pub fn (p &ClientBoundDataDrivenUICloseAllScreensPacket) name() string {
	return 'ClientBoundDataDrivenUICloseAllScreensPacket'
}

pub fn (p &ClientBoundDataDrivenUICloseAllScreensPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &ClientBoundDataDrivenUICloseAllScreensPacket) encode_payload(mut w serializer.Writer) {
}

pub fn (mut p ClientBoundDataDrivenUICloseAllScreensPacket) decode_payload(mut r serializer.Reader) ! {
}
