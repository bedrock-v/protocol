module packets

import protocol.serializer
import protocol.version.v291.types

pub const delta_flag_has_x = u8(0x01)
pub const delta_flag_has_y = u8(0x02)
pub const delta_flag_has_z = u8(0x04)
pub const delta_flag_has_pitch = u8(0x08)
pub const delta_flag_has_yaw = u8(0x10)
pub const delta_flag_has_head_yaw = u8(0x20)
pub const delta_flag_on_ground = u8(0x40)
pub const delta_flag_teleporting = u8(0x80)

pub struct MoveEntityDeltaPacket {
pub mut:
	runtime_entity_id u64
	flags             u8
	delta_x           i32
	delta_y           i32
	delta_z           i32
	pitch             f32
	yaw               f32
	head_yaw          f32
}

pub fn (p &MoveEntityDeltaPacket) pid() u16 {
	return 111
}

pub fn (p &MoveEntityDeltaPacket) name() string {
	return 'MoveEntityDeltaPacket'
}

pub fn (p &MoveEntityDeltaPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &MoveEntityDeltaPacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint64(p.runtime_entity_id)
	w.u8(p.flags)
	if p.flags & delta_flag_has_x != 0 {
		w.write_varint32(p.delta_x)
	}
	if p.flags & delta_flag_has_y != 0 {
		w.write_varint32(p.delta_y)
	}
	if p.flags & delta_flag_has_z != 0 {
		w.write_varint32(p.delta_z)
	}
	if p.flags & delta_flag_has_pitch != 0 {
		types.write_byte_angle(mut w, p.pitch)
	}
	if p.flags & delta_flag_has_yaw != 0 {
		types.write_byte_angle(mut w, p.yaw)
	}
	if p.flags & delta_flag_has_head_yaw != 0 {
		types.write_byte_angle(mut w, p.head_yaw)
	}
}

pub fn (mut p MoveEntityDeltaPacket) decode_payload(mut r serializer.Reader) ! {
	p.runtime_entity_id = r.read_varuint64()!
	p.flags = r.u8()!
	if p.flags & delta_flag_has_x != 0 {
		p.delta_x = r.read_varint32()!
	}
	if p.flags & delta_flag_has_y != 0 {
		p.delta_y = r.read_varint32()!
	}
	if p.flags & delta_flag_has_z != 0 {
		p.delta_z = r.read_varint32()!
	}
	if p.flags & delta_flag_has_pitch != 0 {
		p.pitch = types.read_byte_angle(mut r)!
	}
	if p.flags & delta_flag_has_yaw != 0 {
		p.yaw = types.read_byte_angle(mut r)!
	}
	if p.flags & delta_flag_has_head_yaw != 0 {
		p.head_yaw = types.read_byte_angle(mut r)!
	}
}
