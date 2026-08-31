module packets

import protocol.serializer

pub struct AddPaintingPacket {
pub mut:
	eid       i64
	x         i32
	y         i32
	z         i32
	direction i32
	title     string
}

pub fn (p &AddPaintingPacket) pid() u16 {
	return 0x92
}

pub fn (p &AddPaintingPacket) name() string {
	return 'AddPaintingPacket'
}

pub fn (p &AddPaintingPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &AddPaintingPacket) encode_payload(mut w serializer.Writer) {
	w.be_i64(p.eid)
	w.be_i32(p.x)
	w.be_i32(p.y)
	w.be_i32(p.z)
	w.be_i32(p.direction)
	w.write_string_be(p.title)
}

pub fn (mut p AddPaintingPacket) decode_payload(mut r serializer.Reader) ! {
	p.eid = r.be_i64()!
	p.x = r.be_i32()!
	p.y = r.be_i32()!
	p.z = r.be_i32()!
	p.direction = r.be_i32()!
	p.title = r.read_string_be()!
}
