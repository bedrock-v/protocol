module packets

import serializer

pub struct AddEntityPacket {
pub mut:
	eid     i32
	typ     u8
	x       f32
	y       f32
	z       f32
	did     i32
	speed_x i16
	speed_y i16
	speed_z i16
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
	w.be_i32(p.did)
	if p.did > 0 {
		w.be_i16(p.speed_x)
		w.be_i16(p.speed_y)
		w.be_i16(p.speed_z)
	}
}

pub fn (mut p AddEntityPacket) decode_payload(mut r serializer.Reader) ! {
	p.eid = r.be_i32()!
	p.typ = r.u8()!
	p.x = r.be_f32()!
	p.y = r.be_f32()!
	p.z = r.be_f32()!
	p.did = r.be_i32()!
	if p.did > 0 {
		p.speed_x = r.be_i16()!
		p.speed_y = r.be_i16()!
		p.speed_z = r.be_i16()!
	}
}
