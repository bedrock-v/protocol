module packets

import protocol.serializer
import protocol.version.v137.types

pub struct MovePlayerPacket {
pub mut:
	entity_runtime_id        u64
	position                 types.Vector3f
	pitch                    f32
	yaw                      f32
	body_yaw                 f32
	mode                     u8
	on_ground                bool
	riding_entity_runtime_id u64
	int1                     i32
	int2                     i32
}

pub fn (p &MovePlayerPacket) pid() u16 {
	return 19
}

pub fn (p &MovePlayerPacket) name() string {
	return 'MovePlayerPacket'
}

pub fn (p &MovePlayerPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &MovePlayerPacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint64(p.entity_runtime_id)
	p.position.encode(mut w)
	w.le_f32(p.pitch)
	w.le_f32(p.yaw)
	w.le_f32(p.body_yaw)
	w.u8(p.mode)
	w.bool(p.on_ground)
	w.write_varuint64(p.riding_entity_runtime_id)
	if p.mode == 2 {
		w.le_i32(p.int1)
		w.le_i32(p.int2)
	}
}

pub fn (mut p MovePlayerPacket) decode_payload(mut r serializer.Reader) ! {
	p.entity_runtime_id = r.read_varuint64()!
	p.position = types.Vector3f.decode(mut r)!
	p.pitch = r.le_f32()!
	p.yaw = r.le_f32()!
	p.body_yaw = r.le_f32()!
	p.mode = r.u8()!
	p.on_ground = r.bool()!
	p.riding_entity_runtime_id = r.read_varuint64()!
	if p.mode == 2 {
		p.int1 = r.le_i32()!
		p.int2 = r.le_i32()!
	}
}
