module packets

import protocol.serializer

pub struct MessagePacket {
pub mut:
	message string
}

pub fn (p &MessagePacket) pid() u16 {
	return 0x85
}

pub fn (p &MessagePacket) name() string {
	return 'MessagePacket'
}

pub fn (p &MessagePacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &MessagePacket) encode_payload(mut w serializer.Writer) {
	w.write_string_be(p.message)
}

pub fn (mut p MessagePacket) decode_payload(mut r serializer.Reader) ! {
	p.message = r.read_string_be()!
}
