module packets

import serializer

pub struct LoginPacket {
pub mut:
	client_network_version i32
	connection_request     []u8
}

pub fn (p &LoginPacket) pid() u16 { return 1 }

pub fn (p &LoginPacket) name() string { return 'LoginPacket' }

pub fn (p &LoginPacket) can_be_sent_before_login() bool { return true }

pub fn (p &LoginPacket) encode_payload(mut w serializer.Writer) {
	w.be_i32(p.client_network_version)
	w.write_string_bytes(p.connection_request)
}

pub fn (mut p LoginPacket) decode_payload(mut r serializer.Reader) ! {
	p.client_network_version = r.be_i32()!
	p.connection_request = r.read_string_bytes()!
}
