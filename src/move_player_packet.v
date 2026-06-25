module src

import src.serializer
import src.types

pub const move_player_mode_normal = 0
pub const move_player_mode_reset = 1
pub const move_player_mode_teleport = 2
pub const move_player_mode_pitch = 3

pub struct MovePlayerPacket {
pub mut:
	actor_runtime_id         u64
	position                 types.Vector3
	pitch                    f32
	yaw                      f32
	head_yaw                 f32
	mode                     int
	on_ground                bool
	riding_actor_runtime_id  u64
	teleport_cause           int
	teleport_item            int
	tick                     u64
}

pub fn (p &MovePlayerPacket) pid() u16 {
	return move_player_packet
}

pub fn (p &MovePlayerPacket) name() string {
	return 'MovePlayerPacket'
}

pub fn (p &MovePlayerPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p MovePlayerPacket) decode_payload(mut r serializer.Reader) ! {
	p.actor_runtime_id = r.read_actor_runtime_id()!
	p.position = r.read_vector3()!
	p.pitch = r.le_f32()!
	p.yaw = r.le_f32()!
	p.head_yaw = r.le_f32()!
	p.mode = int(r.u8()!)
	p.on_ground = r.bool()!
	p.riding_actor_runtime_id = r.read_actor_runtime_id()!
	if p.mode == move_player_mode_teleport {
		p.teleport_cause = int(r.le_i32()!)
		p.teleport_item = int(r.le_i32()!)
	}
	p.tick = r.read_varuint64()!
}

pub fn (p &MovePlayerPacket) encode_payload(mut w serializer.Writer) {
	w.write_actor_runtime_id(p.actor_runtime_id)
	w.write_vector3(p.position)
	w.le_f32(p.pitch)
	w.le_f32(p.yaw)
	w.le_f32(p.head_yaw)
	w.u8(u8(p.mode))
	w.bool(p.on_ground)
	w.write_actor_runtime_id(p.riding_actor_runtime_id)
	if p.mode == move_player_mode_teleport {
		w.le_i32(i32(p.teleport_cause))
		w.le_i32(i32(p.teleport_item))
	}
	w.write_varuint64(p.tick)
}
