module packets

import serializer

pub struct DisconnectPacket {
pub mut:
	message_skipped bool
	kick_message    string
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
	w.bool(p.message_skipped)
	if !p.message_skipped {
		w.write_string(p.kick_message)
	}
}

pub fn (mut p DisconnectPacket) decode_payload(mut r serializer.Reader) ! {
	p.message_skipped = r.bool()!
	if !p.message_skipped {
		p.kick_message = r.read_string()!
	}
}
