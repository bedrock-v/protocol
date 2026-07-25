module packets

import serializer

pub struct ShowProfilePacket {
pub mut:
	string1 string
}

pub fn (p &ShowProfilePacket) pid() u16 {
	return 104
}

pub fn (p &ShowProfilePacket) name() string {
	return 'ShowProfilePacket'
}

pub fn (p &ShowProfilePacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &ShowProfilePacket) encode_payload(mut w serializer.Writer) {
	w.write_string(p.string1)
}

pub fn (mut p ShowProfilePacket) decode_payload(mut r serializer.Reader) ! {
	p.string1 = r.read_string()!
}
