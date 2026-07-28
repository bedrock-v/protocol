module packets

import protocol.serializer

pub struct SetEntityMotionPacket {
pub mut:
	eid      i32
	motion_x f32
	motion_y f32
	motion_z f32
}

pub fn (p &SetEntityMotionPacket) pid() u16 {
	return 0x27
}

pub fn (p &SetEntityMotionPacket) name() string {
	return 'SetEntityMotionPacket'
}

pub fn (p &SetEntityMotionPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &SetEntityMotionPacket) encode_payload(mut w serializer.Writer) {
	w.write_varint32(p.eid)
	w.le_f32(p.motion_x)
	w.le_f32(p.motion_y)
	w.le_f32(p.motion_z)
}

pub fn (mut p SetEntityMotionPacket) decode_payload(mut r serializer.Reader) ! {
	p.eid = r.read_varint32()!
	p.motion_x = r.le_f32()!
	p.motion_y = r.le_f32()!
	p.motion_z = r.le_f32()!
}
