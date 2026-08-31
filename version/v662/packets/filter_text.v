module packets

import protocol.serializer

pub struct FilterTextPacket {
pub mut:
	text        string
	from_server bool
}

pub fn (p &FilterTextPacket) pid() u16 {
	return 163
}

pub fn (p &FilterTextPacket) name() string {
	return 'FilterTextPacket'
}

pub fn (p &FilterTextPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &FilterTextPacket) encode_payload(mut w serializer.Writer) {
	w.write_string(p.text)
	w.bool(p.from_server)
}

pub fn (mut p FilterTextPacket) decode_payload(mut r serializer.Reader) ! {
	p.text = r.read_string()!
	p.from_server = r.bool()!
}
