module packets

import protocol.serializer
import protocol.version.v662.types

pub struct AutomationClientConnectPacket {
pub mut:
	web_socket_data types.WebSocketPacketData
}

pub fn (p &AutomationClientConnectPacket) pid() u16 {
	return 95
}

pub fn (p &AutomationClientConnectPacket) name() string {
	return 'AutomationClientConnectPacket'
}

pub fn (p &AutomationClientConnectPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &AutomationClientConnectPacket) encode_payload(mut w serializer.Writer) {
	p.web_socket_data.encode(mut w)
}

pub fn (mut p AutomationClientConnectPacket) decode_payload(mut r serializer.Reader) ! {
	p.web_socket_data = types.WebSocketPacketData.decode(mut r)!
}
