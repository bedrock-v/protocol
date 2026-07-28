module packets

import protocol.serializer

pub struct MoveEntityPacket {
pub mut:
	eid      i64
	x        f32
	y        f32
	z        f32
	pitch    u8
	yaw      u8
	head_yaw u8
}

pub fn (p &MoveEntityPacket) pid() u16 {
	return 0x10
}

pub fn (p &MoveEntityPacket) name() string {
	return 'MoveEntityPacket'
}

pub fn (p &MoveEntityPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &MoveEntityPacket) encode_payload(mut w serializer.Writer) {
	w.be_i64(p.eid)
	w.be_f32(p.x)
	w.be_f32(p.y)
	w.be_f32(p.z)
	w.u8(p.pitch)
	w.u8(p.yaw)
	w.u8(p.head_yaw)
}

pub fn (mut p MoveEntityPacket) decode_payload(mut r serializer.Reader) ! {
	p.eid = r.be_i64()!
	p.x = r.be_f32()!
	p.y = r.be_f32()!
	p.z = r.be_f32()!
	p.pitch = r.u8()!
	p.yaw = r.u8()!
	p.head_yaw = r.u8()!
}
