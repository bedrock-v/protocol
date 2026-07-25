module packets

import serializer

pub struct TextPacket {
pub mut:
	type       u8
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
	w.u8(p.type)
	if p.type == 1 || p.type == 3 {
		w.write_string(p.source)
		w.write_string(p.message)
	} else if p.type == 2 {
		w.write_string(p.message)
		w.u8(u8(p.parameters.len))
		for s in p.parameters {
			w.write_string(s)
		}
	} else {
		w.write_string(p.message)
	}
}

pub fn (mut p TextPacket) decode_payload(mut r serializer.Reader) ! {
	p.type = r.u8()!
	if p.type == 1 || p.type == 3 {
		p.source = r.read_string()!
		p.message = r.read_string()!
	} else if p.type == 2 {
		p.message = r.read_string()!
		n := int(r.u8()!)
		for _ in 0 .. n {
			p.parameters << r.read_string()!
		}
	} else {
		p.message = r.read_string()!
	}
}
