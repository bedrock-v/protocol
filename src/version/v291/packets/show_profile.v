module packets

import protocol.serializer

pub struct ShowProfilePacket {
pub mut:
	xuid string
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
	w.write_string(p.xuid)
}

pub fn (mut p ShowProfilePacket) decode_payload(mut r serializer.Reader) ! {
	p.xuid = r.read_string()!
}
