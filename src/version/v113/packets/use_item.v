module packets

import serializer
import version.v113.types

pub struct UseItemPacket {
pub mut:
	x        i32
	y        u32
	z        i32
	block_id u32
	face     i32
	fx       f32
	fy       f32
	fz       f32
	pos_x    f32
	pos_y    f32
	pos_z    f32
	slot     i32
	item     types.EraBItem
}

pub fn (p &UseItemPacket) pid() u16 {
	return 0x23
}

pub fn (p &UseItemPacket) name() string {
	return 'UseItemPacket'
}

pub fn (p &UseItemPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &UseItemPacket) encode_payload(mut w serializer.Writer) {
	w.write_varint32(p.x)
	w.write_varuint32(p.y)
	w.write_varint32(p.z)
	w.write_varuint32(p.block_id)
	w.write_varint32(p.face)
	w.le_f32(p.fx)
	w.le_f32(p.fy)
	w.le_f32(p.fz)
	w.le_f32(p.pos_x)
	w.le_f32(p.pos_y)
	w.le_f32(p.pos_z)
	w.write_varint32(p.slot)
	p.item.encode(mut w)
}

pub fn (mut p UseItemPacket) decode_payload(mut r serializer.Reader) ! {
	p.x = r.read_varint32()!
	p.y = r.read_varuint32()!
	p.z = r.read_varint32()!
	p.block_id = r.read_varuint32()!
	p.face = r.read_varint32()!
	p.fx = r.le_f32()!
	p.fy = r.le_f32()!
	p.fz = r.le_f32()!
	p.pos_x = r.le_f32()!
	p.pos_y = r.le_f32()!
	p.pos_z = r.le_f32()!
	p.slot = r.read_varint32()!
	p.item = types.EraBItem.decode(mut r)!
}
