module packets

import serializer

pub struct SubClientLoginPacket {
pub mut:
	connection_request string
}

pub fn (p &SubClientLoginPacket) pid() u16 { return 94 }

pub fn (p &SubClientLoginPacket) name() string { return 'SubClientLoginPacket' }

pub fn (p &SubClientLoginPacket) can_be_sent_before_login() bool { return false }

pub fn (p &SubClientLoginPacket) encode_payload(mut w serializer.Writer) {
	w.write_string(p.connection_request)
}

pub fn (mut p SubClientLoginPacket) decode_payload(mut r serializer.Reader) ! {
	p.connection_request = r.read_string()!
}
