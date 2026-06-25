module src

import src.serializer

pub struct DisconnectPacket {
pub mut:
	reason           int
	message          ?string
	filtered_message ?string
}

pub fn (p &DisconnectPacket) pid() u16 {
	return disconnect_packet
}

pub fn (p &DisconnectPacket) name() string {
	return 'DisconnectPacket'
}

pub fn (p &DisconnectPacket) can_be_sent_before_login() bool {
	return true
}

pub fn (mut p DisconnectPacket) decode_payload(mut r serializer.Reader) ! {
	p.reason = int(r.read_varint32()!)
	skip_message := r.read_varuint32()!
	if skip_message == 0 {
		p.message = r.read_string()!
		p.filtered_message = r.read_string()!
	} else {
		p.message = none
		p.filtered_message = none
	}
}

pub fn (p &DisconnectPacket) encode_payload(mut w serializer.Writer) {
	w.write_varint32(i32(p.reason))
	has_message := p.message != none || p.filtered_message != none
	w.write_varuint32(if has_message { u32(0) } else { u32(1) })
	if has_message {
		w.write_string(p.message or { '' })
		w.write_string(p.filtered_message or { '' })
	}
}
