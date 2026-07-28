module packets

import protocol.serializer

pub struct TileEventPacket {
pub mut:
	x     i32
	y     i32
	z     i32
	case1 i32
	case2 i32
}

pub fn (p &TileEventPacket) pid() u16 {
	return 0x9c
}

pub fn (p &TileEventPacket) name() string {
	return 'TileEventPacket'
}

pub fn (p &TileEventPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &TileEventPacket) encode_payload(mut w serializer.Writer) {
	w.be_i32(p.x)
	w.be_i32(p.y)
	w.be_i32(p.z)
	w.be_i32(p.case1)
	w.be_i32(p.case2)
}

pub fn (mut p TileEventPacket) decode_payload(mut r serializer.Reader) ! {
	p.x = r.be_i32()!
	p.y = r.be_i32()!
	p.z = r.be_i32()!
	p.case1 = r.be_i32()!
	p.case2 = r.be_i32()!
}
