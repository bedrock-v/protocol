module src

import src.serializer

pub const move_actor_delta_flag_has_x = 0x01
pub const move_actor_delta_flag_has_y = 0x02
pub const move_actor_delta_flag_has_z = 0x04
pub const move_actor_delta_flag_has_pitch = 0x08
pub const move_actor_delta_flag_has_yaw = 0x10
pub const move_actor_delta_flag_has_head_yaw = 0x20

pub struct MoveActorDeltaPacket {
pub mut:
	actor_runtime_id u64
	flags            int
	x_pos            f32
	y_pos            f32
	z_pos            f32
	pitch            f32
	yaw              f32
	head_yaw         f32
}

pub fn (p &MoveActorDeltaPacket) pid() u16 {
	return move_actor_delta_packet
}

pub fn (p &MoveActorDeltaPacket) name() string {
	return 'MoveActorDeltaPacket'
}

pub fn (p &MoveActorDeltaPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p MoveActorDeltaPacket) decode_payload(mut r serializer.Reader) ! {
	p.actor_runtime_id = r.read_actor_runtime_id()!
	p.flags = int(r.le_u16()!)
	if p.flags & move_actor_delta_flag_has_x != 0 {
		p.x_pos = r.le_f32()!
	}
	if p.flags & move_actor_delta_flag_has_y != 0 {
		p.y_pos = r.le_f32()!
	}
	if p.flags & move_actor_delta_flag_has_z != 0 {
		p.z_pos = r.le_f32()!
	}
	if p.flags & move_actor_delta_flag_has_pitch != 0 {
		p.pitch = r.read_rotation_byte()!
	}
	if p.flags & move_actor_delta_flag_has_yaw != 0 {
		p.yaw = r.read_rotation_byte()!
	}
	if p.flags & move_actor_delta_flag_has_head_yaw != 0 {
		p.head_yaw = r.read_rotation_byte()!
	}
}

pub fn (p &MoveActorDeltaPacket) encode_payload(mut w serializer.Writer) {
	w.write_actor_runtime_id(p.actor_runtime_id)
	w.le_u16(u16(p.flags))
	if p.flags & move_actor_delta_flag_has_x != 0 {
		w.le_f32(p.x_pos)
	}
	if p.flags & move_actor_delta_flag_has_y != 0 {
		w.le_f32(p.y_pos)
	}
	if p.flags & move_actor_delta_flag_has_z != 0 {
		w.le_f32(p.z_pos)
	}
	if p.flags & move_actor_delta_flag_has_pitch != 0 {
		w.write_rotation_byte(p.pitch)
	}
	if p.flags & move_actor_delta_flag_has_yaw != 0 {
		w.write_rotation_byte(p.yaw)
	}
	if p.flags & move_actor_delta_flag_has_head_yaw != 0 {
		w.write_rotation_byte(p.head_yaw)
	}
}
