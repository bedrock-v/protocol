module packets

import serializer

pub struct DisconnectPacket {
pub mut:
	hide_disconnection_screen bool
	message                   string
}

pub fn (p &DisconnectPacket) pid() u16 {
	return 0x05
}

pub fn (p &DisconnectPacket) name() string {
	return 'DisconnectPacket'
}

pub fn (p &DisconnectPacket) can_be_sent_before_login() bool {
	return true
}

pub fn (p &DisconnectPacket) encode_payload(mut w serializer.Writer) {
	w.u8(if p.hide_disconnection_screen { u8(1) } else { u8(0) })
	w.write_string(p.message)
}

pub fn (mut p DisconnectPacket) decode_payload(mut r serializer.Reader) ! {
	p.hide_disconnection_screen = r.u8()! > 0
	p.message = r.read_string()!
}
