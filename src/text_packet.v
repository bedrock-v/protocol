module protocol

import serializer

pub const text_category_message_only = 0
pub const text_category_authored_message = 1
pub const text_category_message_with_parameters = 2

pub struct TextPacket {
pub mut:
	@type             int
	needs_translation bool
	source_name       string
	message           string
	parameters        []string
	xbox_user_id      string
	platform_chat_id  string
	filtered_message  ?string
}

pub fn (p &TextPacket) pid() u16 {
	return text_packet
}

pub fn (p &TextPacket) name() string {
	return 'TextPacket'
}

pub fn (p &TextPacket) can_be_sent_before_login() bool {
	return false
}

fn text_category_for(t int) int {
	return match t {
		1, 7, 8 { text_category_authored_message }
		2, 3, 4 { text_category_message_with_parameters }
		else { text_category_message_only }
	}
}

pub fn (mut p TextPacket) decode_payload(mut r serializer.Reader) ! {
	p.needs_translation = r.bool()!
	r.u8()!
	p.@type = int(r.u8()!)
	match p.@type {
		1, 7, 8 {
			p.source_name = r.read_string()!
			p.message = r.read_string()!
		}
		2, 3, 4 {
			p.message = r.read_string()!
			count := int(r.read_varuint32()!)
			p.parameters = []string{}
			for _ in 0 .. count {
				p.parameters << r.read_string()!
			}
		}
		else {
			p.message = r.read_string()!
		}
	}
	p.xbox_user_id = r.read_string()!
	p.platform_chat_id = r.read_string()!
	if r.bool()! {
		p.filtered_message = r.read_string()!
	} else {
		p.filtered_message = none
	}
}

pub fn (p &TextPacket) encode_payload(mut w serializer.Writer) {
	w.bool(p.needs_translation)
	w.u8(u8(text_category_for(p.@type)))
	w.u8(u8(p.@type))
	match p.@type {
		1, 7, 8 {
			w.write_string(p.source_name)
			w.write_string(p.message)
		}
		2, 3, 4 {
			w.write_string(p.message)
			w.write_varuint32(u32(p.parameters.len))
			for param in p.parameters {
				w.write_string(param)
			}
		}
		else {
			w.write_string(p.message)
		}
	}
	w.write_string(p.xbox_user_id)
	w.write_string(p.platform_chat_id)
	if filtered := p.filtered_message {
		w.bool(true)
		w.write_string(filtered)
	} else {
		w.bool(false)
	}
}
