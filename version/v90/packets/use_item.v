module packets

import protocol.serializer
import protocol.version.v90.types

pub struct UseItemPacket {
pub mut:
	x     i32
	y     i32
	z     i32
	face  u8
	fx    f32
	fy    f32
	fz    f32
	pos_x f32
	pos_y f32
	pos_z f32
	slot  i32
	item  types.EraBItem
}

pub fn (p &UseItemPacket) pid() u16 {
	return 0x20
}

pub fn (p &UseItemPacket) name() string {
	return 'UseItemPacket'
}

pub fn (p &UseItemPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &UseItemPacket) encode_payload(mut w serializer.Writer) {
	w.be_i32(p.x)
	w.be_i32(p.y)
	w.be_i32(p.z)
	w.u8(p.face)
	w.be_f32(p.fx)
	w.be_f32(p.fy)
	w.be_f32(p.fz)
	w.be_f32(p.pos_x)
	w.be_f32(p.pos_y)
	w.be_f32(p.pos_z)
	w.be_i32(p.slot)
	p.item.encode(mut w)
}

pub fn (mut p UseItemPacket) decode_payload(mut r serializer.Reader) ! {
	p.x = r.be_i32()!
	p.y = r.be_i32()!
	p.z = r.be_i32()!
	p.face = r.u8()!
	p.fx = r.be_f32()!
	p.fy = r.be_f32()!
	p.fz = r.be_f32()!
	p.pos_x = r.be_f32()!
	p.pos_y = r.be_f32()!
	p.pos_z = r.be_f32()!
	p.slot = r.be_i32()!
	p.item = types.EraBItem.decode(mut r)!
}
