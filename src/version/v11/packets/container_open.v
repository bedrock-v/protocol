module packets

import serializer

pub struct ContainerOpenPacket {
pub mut:
	windowid u8
	typ      u8
	slots    u16
	title    string
}

pub fn (p &ContainerOpenPacket) pid() u16 {
	return 0xaf
}

pub fn (p &ContainerOpenPacket) name() string {
	return 'ContainerOpenPacket'
}

pub fn (p &ContainerOpenPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &ContainerOpenPacket) encode_payload(mut w serializer.Writer) {
	w.u8(p.windowid)
	w.u8(p.typ)
	w.be_u16(p.slots)
	w.write_string_be(p.title)
}

pub fn (mut p ContainerOpenPacket) decode_payload(mut r serializer.Reader) ! {
	p.windowid = r.u8()!
	p.typ = r.u8()!
	p.slots = r.be_u16()!
	p.title = r.read_string_be()!
}
