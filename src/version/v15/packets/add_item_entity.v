module packets

import serializer
import version.v14.types

pub struct AddItemEntityPacket {
pub mut:
	eid   i32
	item  types.OldItem
	x     f32
	y     f32
	z     f32
	yaw   i8
	pitch i8
	roll  i8
}

pub fn (p &AddItemEntityPacket) pid() u16 {
	return 0x8e
}

pub fn (p &AddItemEntityPacket) name() string {
	return 'AddItemEntityPacket'
}

pub fn (p &AddItemEntityPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &AddItemEntityPacket) encode_payload(mut w serializer.Writer) {
	w.be_i32(p.eid)
	p.item.encode(mut w)
	w.be_f32(p.x)
	w.be_f32(p.y)
	w.be_f32(p.z)
	w.i8(p.yaw)
	w.i8(p.pitch)
	w.i8(p.roll)
}

pub fn (mut p AddItemEntityPacket) decode_payload(mut r serializer.Reader) ! {
	p.eid = r.be_i32()!
	p.item = types.OldItem.decode(mut r)!
	p.x = r.be_f32()!
	p.y = r.be_f32()!
	p.z = r.be_f32()!
	p.yaw = r.i8()!
	p.pitch = r.i8()!
	p.roll = r.i8()!
}
