module packets

import serializer

pub struct TextPacket {
pub mut:
	text_type         u8
	needs_translation bool
	source            string
	message           string
	parameters        []string
	xbox_user_id      string
}

pub fn (p &TextPacket) pid() u16 {
	return 9
}

pub fn (p &TextPacket) name() string {
	return 'TextPacket'
}

pub fn (p &TextPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &TextPacket) encode_payload(mut w serializer.Writer) {
	w.u8(p.text_type)
	w.bool(p.needs_translation)
	match p.text_type {
		1, 7, 8 {
			w.write_string(p.source)
			w.write_string(p.message)
		}
		0, 5, 6 {
			w.write_string(p.message)
		}
		2, 3, 4 {
			w.write_string(p.message)
			w.write_varuint32(u32(p.parameters.len))
			for param in p.parameters {
				w.write_string(param)
			}
		}
		else {}
	}
	w.write_string(p.xbox_user_id)
}

pub fn (mut p TextPacket) decode_payload(mut r serializer.Reader) ! {
	p.text_type = r.u8()!
	p.needs_translation = r.bool()!
	match p.text_type {
		1, 7, 8 {
			p.source = r.read_string()!
			p.message = r.read_string()!
		}
		0, 5, 6 {
			p.message = r.read_string()!
		}
		2, 3, 4 {
			p.message = r.read_string()!
			count := int(r.read_varuint32()!)
			mut parameters := []string{cap: count}
			for _ in 0 .. count {
				parameters << r.read_string()!
			}
			p.parameters = parameters
		}
		else {}
	}
	p.xbox_user_id = r.read_string()!
}
