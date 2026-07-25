module packets

import serializer

pub struct MoveEntityPacket {
pub mut:
	eid      i32
	x        f32
	y        f32
	z        f32
	pitch    u8
	yaw      u8
	head_yaw u8
}

pub fn (p &MoveEntityPacket) pid() u16 {
	return 0x13
}

pub fn (p &MoveEntityPacket) name() string {
	return 'MoveEntityPacket'
}

pub fn (p &MoveEntityPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &MoveEntityPacket) encode_payload(mut w serializer.Writer) {
	w.write_varint32(p.eid)
	w.le_f32(p.x)
	w.le_f32(p.y)
	w.le_f32(p.z)
	w.u8(p.pitch)
	w.u8(p.yaw)
	w.u8(p.head_yaw)
}

pub fn (mut p MoveEntityPacket) decode_payload(mut r serializer.Reader) ! {
	p.eid = r.read_varint32()!
	p.x = r.le_f32()!
	p.y = r.le_f32()!
	p.z = r.le_f32()!
	p.pitch = r.u8()!
	p.yaw = r.u8()!
	p.head_yaw = r.u8()!
}
