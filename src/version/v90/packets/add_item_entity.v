module packets

import serializer
import version.v90.types

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
	return 0x0d
}

pub fn (p &AddItemEntityPacket) name() string {
	return 'AddItemEntityPacket'
}

pub fn (p &AddItemEntityPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &AddItemEntityPacket) encode_payload(mut w serializer.Writer) {
	w.be_i64(p.eid)
	p.item.encode(mut w)
	w.be_f32(p.x)
	w.be_f32(p.y)
	w.be_f32(p.z)
	w.be_f32(p.speed_x)
	w.be_f32(p.speed_y)
	w.be_f32(p.speed_z)
}

pub fn (mut p AddItemEntityPacket) decode_payload(mut r serializer.Reader) ! {
	p.eid = r.be_i64()!
	p.item = types.EraBItem.decode(mut r)!
	p.x = r.be_f32()!
	p.y = r.be_f32()!
	p.z = r.be_f32()!
	p.speed_x = r.be_f32()!
	p.speed_y = r.be_f32()!
	p.speed_z = r.be_f32()!
}
