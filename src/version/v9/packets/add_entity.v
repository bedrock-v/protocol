module packets

import serializer

pub struct AddEntityPacket {
pub mut:
	eid i32
	typ u8
	x   f32
	y   f32
	z   f32
}

pub fn (p &AddEntityPacket) pid() u16 {
	return 0x8c
}

pub fn (p &AddEntityPacket) name() string {
	return 'AddEntityPacket'
}

pub fn (p &AddEntityPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &AddEntityPacket) encode_payload(mut w serializer.Writer) {
	w.be_i32(p.eid)
	w.u8(p.typ)
	w.be_f32(p.x)
	w.be_f32(p.y)
	w.be_f32(p.z)
	w.write_raw([u8(0x00), 0x00, 0x00, 0x02, 0x00, 0x00, 0xff, 0xd3, 0x00, 0x00])
}

pub fn (mut p AddEntityPacket) decode_payload(mut r serializer.Reader) ! {
	p.eid = r.be_i32()!
	p.typ = r.u8()!
	p.x = r.be_f32()!
	p.y = r.be_f32()!
	p.z = r.be_f32()!
}
