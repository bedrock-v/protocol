module packets

import protocol.serializer

pub struct MovePlayerPacket {
pub mut:
	eid       i32
	x         f32
	y         f32
	z         f32
	pitch     f32
	yaw       f32
	body_yaw  f32
	mode      u8
	on_ground bool
}

pub fn (p &MovePlayerPacket) pid() u16 {
	return 0x14
}

pub fn (p &MovePlayerPacket) name() string {
	return 'MovePlayerPacket'
}

pub fn (p &MovePlayerPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &MovePlayerPacket) encode_payload(mut w serializer.Writer) {
	w.write_varint32(p.eid)
	w.le_f32(p.x)
	w.le_f32(p.y)
	w.le_f32(p.z)
	w.le_f32(p.pitch)
	w.le_f32(p.yaw)
	w.le_f32(p.body_yaw)
	w.u8(p.mode)
	w.u8(if p.on_ground { u8(1) } else { u8(0) })
}

pub fn (mut p MovePlayerPacket) decode_payload(mut r serializer.Reader) ! {
	p.eid = r.read_varint32()!
	p.x = r.le_f32()!
	p.y = r.le_f32()!
	p.z = r.le_f32()!
	p.pitch = r.le_f32()!
	p.yaw = r.le_f32()!
	p.body_yaw = r.le_f32()!
	p.mode = r.u8()!
	p.on_ground = r.u8()! > 0
}
