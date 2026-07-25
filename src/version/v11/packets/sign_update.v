module packets

import serializer

pub struct SignUpdatePacket {
pub mut:
	x     i16
	y     u8
	z     i16
	lines [4]string
}

pub fn (p &SignUpdatePacket) pid() u16 {
	return 0xb6
}

pub fn (p &SignUpdatePacket) name() string {
	return 'SignUpdatePacket'
}

pub fn (p &SignUpdatePacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &SignUpdatePacket) encode_payload(mut w serializer.Writer) {
	w.be_i16(p.x)
	w.u8(p.y)
	w.be_i16(p.z)
	for line in p.lines {
		w.le_i16(i16(line.len))
		w.write_raw(line.bytes())
	}
}

pub fn (mut p SignUpdatePacket) decode_payload(mut r serializer.Reader) ! {
	p.x = r.be_i16()!
	p.y = r.u8()!
	p.z = r.be_i16()!
	for i in 0 .. 4 {
		l := int(r.le_i16()!)
		p.lines[i] = r.read_raw(l)!.bytestr()
	}
}
