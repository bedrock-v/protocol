module packets

import protocol.serializer

pub struct StartGamePacket {
pub mut:
	entity_unique_id            i32
	entity_runtime_id           i32
	x                           f32
	y                           f32
	z                           f32
	yaw                         f32
	pitch                       f32
	seed                        i32
	dimension                   i32
	generator                   i32
	gamemode                    i32
	difficulty                  i32
	spawn_x                     i32
	spawn_y                     u8
	spawn_z                     i32
	has_been_loaded_in_creative u8
	day_cycle_stop_time         i32
	edu_mode                    u8
	rain_level                  f32
	lightning_level             f32
	commands_enabled            u8
	unknown                     string
	world_name                  string
}

pub fn (p &StartGamePacket) pid() u16 {
	return 0x09
}

pub fn (p &StartGamePacket) name() string {
	return 'StartGamePacket'
}

pub fn (p &StartGamePacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &StartGamePacket) encode_payload(mut w serializer.Writer) {
	w.write_varint32(p.entity_unique_id)
	w.write_varint32(p.entity_runtime_id)
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
	w.u8(p.spawn_y)
	w.write_varint32(p.spawn_z)
	w.u8(p.has_been_loaded_in_creative)
	w.write_varint32(p.day_cycle_stop_time)
	w.u8(p.edu_mode)
	w.le_f32(p.rain_level)
	w.le_f32(p.lightning_level)
	w.u8(p.commands_enabled)
	w.write_string(p.unknown)
	w.write_string(p.world_name)
}

pub fn (mut p StartGamePacket) decode_payload(mut r serializer.Reader) ! {
	p.entity_unique_id = r.read_varint32()!
	p.entity_runtime_id = r.read_varint32()!
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
	p.spawn_y = r.u8()!
	p.spawn_z = r.read_varint32()!
	p.has_been_loaded_in_creative = r.u8()!
	p.day_cycle_stop_time = r.read_varint32()!
	p.edu_mode = r.u8()!
	p.rain_level = r.le_f32()!
	p.lightning_level = r.le_f32()!
	p.commands_enabled = r.u8()!
	p.unknown = r.read_string()!
	p.world_name = r.read_string()!
}
