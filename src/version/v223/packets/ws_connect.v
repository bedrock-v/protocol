module packets

import protocol.serializer

pub struct WSConnectPacket {
pub mut:
	string1 string
}

pub fn (p &WSConnectPacket) pid() u16 {
	return 95
}

pub fn (p &WSConnectPacket) name() string {
	return 'WSConnectPacket'
}

pub fn (p &WSConnectPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &WSConnectPacket) encode_payload(mut w serializer.Writer) {
	w.write_string(p.string1)
}

pub fn (mut p WSConnectPacket) decode_payload(mut r serializer.Reader) ! {
	p.string1 = r.read_string()!
}
