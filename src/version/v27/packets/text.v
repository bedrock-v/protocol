module packets

import serializer

pub const text_type_raw = u8(0)
pub const text_type_chat = u8(1)
pub const text_type_translation = u8(2)
pub const text_type_popup = u8(3)
pub const text_type_tip = u8(4)

pub struct TextPacket {
pub mut:
	typ        u8
	source     string
	message    string
	parameters []string
}

pub fn (p &TextPacket) pid() u16 {
	return 0x85
}

pub fn (p &TextPacket) name() string {
	return 'TextPacket'
}

pub fn (p &TextPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &TextPacket) encode_payload(mut w serializer.Writer) {
	w.u8(p.typ)
	match p.typ {
		text_type_chat {
			w.write_string_be(p.source)
			w.write_string_be(p.message)
		}
		text_type_translation {
			w.write_string_be(p.message)
			w.u8(u8(p.parameters.len))
			for param in p.parameters {
				w.write_string_be(param)
			}
		}
		else {
			w.write_string_be(p.message)
		}
	}
}

pub fn (mut p TextPacket) decode_payload(mut r serializer.Reader) ! {
	p.typ = r.u8()!
	match p.typ {
		text_type_chat {
			p.source = r.read_string_be()!
			p.message = r.read_string_be()!
		}
		text_type_translation {
			p.message = r.read_string_be()!
			count := int(r.u8()!)
			p.parameters = []string{cap: count}
			for _ in 0 .. count {
				p.parameters << r.read_string_be()!
			}
		}
		else {
			p.message = r.read_string_be()!
		}
	}
}
