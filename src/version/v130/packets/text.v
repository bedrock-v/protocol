module packets

import protocol.serializer

pub struct TextPacket {
pub mut:
	text_type         u8
	needs_translation bool
	source            string
	message           string
	parameters        []string
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
		1, 3, 6, 7 {
			w.write_string(p.source)
			w.write_string(p.message)
		}
		0, 4, 5 {
			w.write_string(p.message)
		}
		2 {
			w.write_string(p.message)
			w.write_varuint32(u32(p.parameters.len))
			for param in p.parameters {
				w.write_string(param)
			}
		}
		else {}
	}
}

pub fn (mut p TextPacket) decode_payload(mut r serializer.Reader) ! {
	p.text_type = r.u8()!
	p.needs_translation = r.bool()!
	match p.text_type {
		1, 3, 6, 7 {
			p.source = r.read_string()!
			p.message = r.read_string()!
		}
		0, 4, 5 {
			p.message = r.read_string()!
		}
		2 {
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
}
