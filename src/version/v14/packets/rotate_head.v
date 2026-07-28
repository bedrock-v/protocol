module packets

import protocol.serializer

pub struct RotateHeadPacket {
pub mut:
	eid   i32
	yaw   f32
	pitch f32
}

pub fn (p &RotateHeadPacket) pid() u16 {
	return 0x94
}

pub fn (p &RotateHeadPacket) name() string {
	return 'RotateHeadPacket'
}

pub fn (p &RotateHeadPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &RotateHeadPacket) encode_payload(mut w serializer.Writer) {
	w.be_i32(p.eid)
	w.be_f32(p.yaw)
	w.be_f32(p.pitch)
}

pub fn (mut p RotateHeadPacket) decode_payload(mut r serializer.Reader) ! {
	p.eid = r.be_i32()!
	p.yaw = r.be_f32()!
	p.pitch = r.be_f32()!
}
