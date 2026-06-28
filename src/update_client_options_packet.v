module protocol

import serializer

pub struct UpdateClientOptionsPacket {
pub mut:
	graphics_mode          ?int
	filter_profanity_change ?bool
}

pub fn (p &UpdateClientOptionsPacket) pid() u16 {
	return update_client_options_packet
}

pub fn (p &UpdateClientOptionsPacket) name() string {
	return 'UpdateClientOptionsPacket'
}

pub fn (p &UpdateClientOptionsPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p UpdateClientOptionsPacket) decode_payload(mut r serializer.Reader) ! {
	if r.bool()! {
		p.graphics_mode = int(r.u8()!)
	} else {
		p.graphics_mode = none
	}
	if r.bool()! {
		p.filter_profanity_change = r.bool()!
	} else {
		p.filter_profanity_change = none
	}
}

pub fn (p &UpdateClientOptionsPacket) encode_payload(mut w serializer.Writer) {
	if mode := p.graphics_mode {
		w.bool(true)
		w.u8(u8(mode))
	} else {
		w.bool(false)
	}
	if change := p.filter_profanity_change {
		w.bool(true)
		w.bool(change)
	} else {
		w.bool(false)
	}
}
