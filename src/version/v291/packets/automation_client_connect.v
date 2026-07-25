module packets

import serializer

pub struct AutomationClientConnectPacket {
pub mut:
	address string
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
	w.write_string(p.address)
}

pub fn (mut p AutomationClientConnectPacket) decode_payload(mut r serializer.Reader) ! {
	p.address = r.read_string()!
}
