module packets

import serializer
import version.v1001.enums

pub struct DisconnectMessage {
pub mut:
	kick_message     string
	filtered_message string
}

pub fn (t DisconnectMessage) encode(mut w serializer.Writer) {
	w.write_string(t.kick_message)
	w.write_string(t.filtered_message)
}

pub fn DisconnectMessage.decode(mut r serializer.Reader) !DisconnectMessage {
	return DisconnectMessage{
		kick_message:     r.read_string()!
		filtered_message: r.read_string()!
	}
}

pub struct DisconnectPacket {
pub mut:
	reason  enums.ConnectionFailReason
	message ?DisconnectMessage
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
	p.reason.encode(mut w)
	if msg := p.message {
		w.bool(false)
		msg.encode(mut w)
	} else {
		w.bool(true)
	}
}

pub fn (mut p DisconnectPacket) decode_payload(mut r serializer.Reader) ! {
	p.reason = enums.ConnectionFailReason.decode(mut r)!
	skip_message := r.bool()!
	if !skip_message {
		p.message = DisconnectMessage.decode(mut r)!
	} else {
		p.message = none
	}
}
