module packets

import protocol.serializer

pub struct ClientMessagePacket {
pub mut:
	message string
}

pub fn (p &ClientMessagePacket) pid() u16 {
	return 0xb5
}

pub fn (p &ClientMessagePacket) name() string {
	return 'ClientMessagePacket'
}

pub fn (p &ClientMessagePacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &ClientMessagePacket) encode_payload(mut w serializer.Writer) {
	w.write_string_be(p.message)
}

pub fn (mut p ClientMessagePacket) decode_payload(mut r serializer.Reader) ! {
	p.message = r.read_string_be()!
}
