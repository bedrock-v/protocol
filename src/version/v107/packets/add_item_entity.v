module packets

import serializer
import version.v107.types

pub struct AddItemEntityPacket {
pub mut:
	eid     i64
	item    types.EraBItem
	x       f32
	y       f32
	z       f32
	speed_x f32
	speed_y f32
	speed_z f32
}

pub fn (p &AddItemEntityPacket) pid() u16 {
	return 0x10
}

pub fn (p &AddItemEntityPacket) name() string {
	return 'AddItemEntityPacket'
}

pub fn (p &AddItemEntityPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &AddItemEntityPacket) encode_payload(mut w serializer.Writer) {
	w.write_varint64(p.eid)
	w.write_varuint64(u64(p.eid))
	p.item.encode(mut w)
	w.le_f32(p.x)
	w.le_f32(p.y)
	w.le_f32(p.z)
	w.le_f32(p.speed_x)
	w.le_f32(p.speed_y)
	w.le_f32(p.speed_z)
}

pub fn (mut p AddItemEntityPacket) decode_payload(mut r serializer.Reader) ! {
	p.eid = r.read_varint64()!
	_ = r.read_varuint64()!
	p.item = types.EraBItem.decode(mut r)!
	p.x = r.le_f32()!
	p.y = r.le_f32()!
	p.z = r.le_f32()!
	p.speed_x = r.le_f32()!
	p.speed_y = r.le_f32()!
	p.speed_z = r.le_f32()!
}
