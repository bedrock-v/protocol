module packets

import serializer
import version.v662.enums

pub struct DisconnectPacket {
pub mut:
	reason  enums.ConnectionFailReason
	message ?string
}

pub fn (p &DisconnectPacket) pid() u16 { return 5 }

pub fn (p &DisconnectPacket) name() string { return 'DisconnectPacket' }

pub fn (p &DisconnectPacket) can_be_sent_before_login() bool { return true }

pub fn (p &DisconnectPacket) encode_payload(mut w serializer.Writer) {
	p.reason.encode(mut w)
	if msg := p.message {
		w.bool(false)
		w.write_string(msg)
	} else {
		w.bool(true)
	}
}

pub fn (mut p DisconnectPacket) decode_payload(mut r serializer.Reader) ! {
	p.reason = enums.ConnectionFailReason.decode(mut r)!
	skip_message := r.bool()!
	if !skip_message {
		p.message = r.read_string()!
	} else {
		p.message = none
	}
}
