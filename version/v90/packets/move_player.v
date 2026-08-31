module packets

import protocol.serializer

pub struct MovePlayerPacket {
pub mut:
	eid       i64
	x         f32
	y         f32
	z         f32
	yaw       f32
	body_yaw  f32
	pitch     f32
	mode      u8
	on_ground bool
}

pub fn (p &MovePlayerPacket) pid() u16 {
	return 0x11
}

pub fn (p &MovePlayerPacket) name() string {
	return 'MovePlayerPacket'
}

pub fn (p &MovePlayerPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &MovePlayerPacket) encode_payload(mut w serializer.Writer) {
	w.be_i64(p.eid)
	w.be_f32(p.x)
	w.be_f32(p.y)
	w.be_f32(p.z)
	w.be_f32(p.yaw)
	w.be_f32(p.body_yaw)
	w.be_f32(p.pitch)
	w.u8(p.mode)
	w.u8(if p.on_ground { u8(1) } else { u8(0) })
}

pub fn (mut p MovePlayerPacket) decode_payload(mut r serializer.Reader) ! {
	p.eid = r.be_i64()!
	p.x = r.be_f32()!
	p.y = r.be_f32()!
	p.z = r.be_f32()!
	p.yaw = r.be_f32()!
	p.body_yaw = r.be_f32()!
	p.pitch = r.be_f32()!
	p.mode = r.u8()!
	p.on_ground = r.u8()! > 0
}
