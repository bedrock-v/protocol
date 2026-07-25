module packets

import serializer

pub struct ContainerOpenPacket {
pub mut:
	windowid u8
	typ      u8
	slots    i16
	x        i32
	y        i32
	z        i32
}

pub fn (p &ContainerOpenPacket) pid() u16 {
	return 0x2a
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
	w.be_i16(p.slots)
	w.be_i32(p.x)
	w.be_i32(p.y)
	w.be_i32(p.z)
}

pub fn (mut p ContainerOpenPacket) decode_payload(mut r serializer.Reader) ! {
	p.windowid = r.u8()!
	p.typ = r.u8()!
	p.slots = r.be_i16()!
	p.x = r.be_i32()!
	p.y = r.be_i32()!
	p.z = r.be_i32()!
}
