module packets

import serializer

pub struct StartGamePacket {
pub mut:
	entity_unique_id          i64
	entity_runtime_id         u64
	x                         f32
	y                         f32
	z                         f32
	yaw                       f32
	pitch                     f32
	seed                      i32
	dimension                 i32
	generator                 i32
	gamemode                  i32
	difficulty                i32
	spawn_x                   i32
	spawn_y                   u32
	spawn_z                   i32
	has_achievements_disabled bool
	day_cycle_stop_time       i32
	edu_mode                  bool
	rain_level                f32
	lightning_level           f32
	commands_enabled          bool
	is_texture_packs_required bool
	level_id                  string
	world_name                string
}

pub fn (p &StartGamePacket) pid() u16 {
	return 0x0c
}

pub fn (p &StartGamePacket) name() string {
	return 'StartGamePacket'
}

pub fn (p &StartGamePacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &StartGamePacket) encode_payload(mut w serializer.Writer) {
	w.write_varint64(p.entity_unique_id)
	w.write_varuint64(p.entity_runtime_id)
	w.le_f32(p.x)
	w.le_f32(p.y)
	w.le_f32(p.z)
	w.le_f32(p.yaw)
	w.le_f32(p.pitch)
	w.write_varint32(p.seed)
	w.write_varint32(p.dimension)
	w.write_varint32(p.generator)
	w.write_varint32(p.gamemode)
	w.write_varint32(p.difficulty)
	w.write_varint32(p.spawn_x)
	w.write_varuint32(p.spawn_y)
	w.write_varint32(p.spawn_z)
	w.u8(if p.has_achievements_disabled { u8(1) } else { u8(0) })
	w.write_varint32(p.day_cycle_stop_time)
	w.u8(if p.edu_mode { u8(1) } else { u8(0) })
	w.le_f32(p.rain_level)
	w.le_f32(p.lightning_level)
	w.u8(if p.commands_enabled { u8(1) } else { u8(0) })
	w.u8(if p.is_texture_packs_required { u8(1) } else { u8(0) })
	w.write_string(p.level_id)
	w.write_string(p.world_name)
}

pub fn (mut p StartGamePacket) decode_payload(mut r serializer.Reader) ! {
	p.entity_unique_id = r.read_varint64()!
	p.entity_runtime_id = r.read_varuint64()!
	p.x = r.le_f32()!
	p.y = r.le_f32()!
	p.z = r.le_f32()!
	p.yaw = r.le_f32()!
	p.pitch = r.le_f32()!
	p.seed = r.read_varint32()!
	p.dimension = r.read_varint32()!
	p.generator = r.read_varint32()!
	p.gamemode = r.read_varint32()!
	p.difficulty = r.read_varint32()!
	p.spawn_x = r.read_varint32()!
	p.spawn_y = r.read_varuint32()!
	p.spawn_z = r.read_varint32()!
	p.has_achievements_disabled = r.u8()! > 0
	p.day_cycle_stop_time = r.read_varint32()!
	p.edu_mode = r.u8()! > 0
	p.rain_level = r.le_f32()!
	p.lightning_level = r.le_f32()!
	p.commands_enabled = r.u8()! > 0
	p.is_texture_packs_required = r.u8()! > 0
	p.level_id = r.read_string()!
	p.world_name = r.read_string()!
}
