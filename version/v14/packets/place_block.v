module packets

import protocol.serializer

pub struct PlaceBlockPacket {
pub mut:
	eid   i32
	x     i32
	z     i32
	y     u8
	block u8
	meta  u8
	face  i8
}

pub fn (p &PlaceBlockPacket) pid() u16 {
	return 0x96
}

pub fn (p &PlaceBlockPacket) name() string {
	return 'PlaceBlockPacket'
}

pub fn (p &PlaceBlockPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &PlaceBlockPacket) encode_payload(mut w serializer.Writer) {
	w.be_i32(p.eid)
	w.be_i32(p.x)
	w.be_i32(p.z)
	w.u8(p.y)
	w.u8(p.block)
	w.u8(p.meta)
	w.i8(p.face)
}

pub fn (mut p PlaceBlockPacket) decode_payload(mut r serializer.Reader) ! {
	p.eid = r.be_i32()!
	p.x = r.be_i32()!
	p.z = r.be_i32()!
	p.y = r.u8()!
	p.block = r.u8()!
	p.meta = r.u8()!
	p.face = r.i8()!
}
