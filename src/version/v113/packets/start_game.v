module packets

import protocol.serializer

pub struct StartGamePacket {
pub mut:
	entity_unique_id          i64
	entity_runtime_id         u64
	player_gamemode           i32
	x                         f32
	y                         f32
	z                         f32
	pitch                     f32
	yaw                       f32
	seed                      i32
	dimension                 i32
	generator                 i32
	world_gamemode            i32
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
	gamerules                 u32
	level_id                  string
	world_name                string
	premium_world_template_id string
}

pub fn (p &StartGamePacket) pid() u16 {
	return 0x0b
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
	w.write_varint32(p.player_gamemode)
	w.le_f32(p.x)
	w.le_f32(p.y)
	w.le_f32(p.z)
	w.le_f32(p.pitch)
	w.le_f32(p.yaw)
	w.write_varint32(p.seed)
	w.write_varint32(p.dimension)
	w.write_varint32(p.generator)
	w.write_varint32(p.world_gamemode)
	w.write_varint32(p.difficulty)
	w.write_varint32(p.spawn_x)
	w.write_varuint32(p.spawn_y)
	w.write_varint32(p.spawn_z)
	w.bool(p.has_achievements_disabled)
	w.write_varint32(p.day_cycle_stop_time)
	w.bool(p.edu_mode)
	w.le_f32(p.rain_level)
	w.le_f32(p.lightning_level)
	w.bool(p.commands_enabled)
	w.bool(p.is_texture_packs_required)
	w.write_varuint32(p.gamerules)
	w.write_string(p.level_id)
	w.write_string(p.world_name)
	w.write_string(p.premium_world_template_id)
}

pub fn (mut p StartGamePacket) decode_payload(mut r serializer.Reader) ! {
	p.entity_unique_id = r.read_varint64()!
	p.entity_runtime_id = r.read_varuint64()!
	p.player_gamemode = r.read_varint32()!
	p.x = r.le_f32()!
	p.y = r.le_f32()!
	p.z = r.le_f32()!
	p.pitch = r.le_f32()!
	p.yaw = r.le_f32()!
	p.seed = r.read_varint32()!
	p.dimension = r.read_varint32()!
	p.generator = r.read_varint32()!
	p.world_gamemode = r.read_varint32()!
	p.difficulty = r.read_varint32()!
	p.spawn_x = r.read_varint32()!
	p.spawn_y = r.read_varuint32()!
	p.spawn_z = r.read_varint32()!
	p.has_achievements_disabled = r.bool()!
	p.day_cycle_stop_time = r.read_varint32()!
	p.edu_mode = r.bool()!
	p.rain_level = r.le_f32()!
	p.lightning_level = r.le_f32()!
	p.commands_enabled = r.bool()!
	p.is_texture_packs_required = r.bool()!
	p.gamerules = r.read_varuint32()!
	p.level_id = r.read_string()!
	p.world_name = r.read_string()!
	p.premium_world_template_id = r.read_string()!
}
