module packets

import protocol.serializer

pub struct TextPacket {
pub mut:
	typ        u8
	source     string
	message    string
	parameters []string
}

pub fn (p &TextPacket) pid() u16 {
	return 0x07
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
		1, 3 {
			w.write_string_be(p.source)
			w.write_string_be(p.message)
		}
		0, 4, 5 {
			w.write_string_be(p.message)
		}
		2 {
			w.write_string_be(p.message)
			w.u8(u8(p.parameters.len))
			for prm in p.parameters {
				w.write_string_be(prm)
			}
		}
		else {}
	}
}

pub fn (mut p TextPacket) decode_payload(mut r serializer.Reader) ! {
	p.typ = r.u8()!
	match p.typ {
		1, 3 {
			p.source = r.read_string_be()!
			p.message = r.read_string_be()!
		}
		0, 4, 5 {
			p.message = r.read_string_be()!
		}
		2 {
			p.message = r.read_string_be()!
			count := int(r.u8()!)
			for _ in 0 .. count {
				p.parameters << r.read_string_be()!
			}
		}
		else {}
	}
}
