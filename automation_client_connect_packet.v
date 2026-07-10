module protocol


pub struct AutomationClientConnectPacket {
pub mut:
	server_uri string
}

pub fn (p &AutomationClientConnectPacket) pid() u16 {
	return automation_client_connect_packet
}

pub fn (p &AutomationClientConnectPacket) name() string {
	return 'AutomationClientConnectPacket'
}

pub fn (p &AutomationClientConnectPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p AutomationClientConnectPacket) decode_payload(mut r Reader) ! {
	p.server_uri = r.read_string()!
}

pub fn (p &AutomationClientConnectPacket) encode_payload(mut w Writer) {
	w.write_string(p.server_uri)
}
