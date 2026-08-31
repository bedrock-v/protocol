module packets

import protocol.serializer

pub struct DisconnectPacket {
pub mut:
	hide_disconnection_screen bool
	message                   string
}

pub fn (p &DisconnectPacket) pid() u16 {
	return 5
}

pub fn (p &DisconnectPacket) name() string {
	return 'DisconnectPacket'
}

pub fn (p &DisconnectPacket) can_be_sent_before_login() bool {
	return true
}

pub fn (p &DisconnectPacket) encode_payload(mut w serializer.Writer) {
	w.bool(p.hide_disconnection_screen)
	if !p.hide_disconnection_screen {
		w.write_string(p.message)
	}
}

pub fn (mut p DisconnectPacket) decode_payload(mut r serializer.Reader) ! {
	p.hide_disconnection_screen = r.bool()!
	if !p.hide_disconnection_screen {
		p.message = r.read_string()!
	}
}
