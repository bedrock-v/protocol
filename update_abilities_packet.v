module protocol


pub const ability_build = 0
pub const ability_mine = 1
pub const ability_doors_and_switches = 2
pub const ability_open_containers = 3
pub const ability_attack_players = 4
pub const ability_attack_mobs = 5
pub const ability_operator_commands = 6
pub const ability_teleport = 7
pub const ability_flying = 9
pub const ability_may_fly = 10
pub const ability_instabuild = 11
pub const ability_walk_speed = 14

pub const ability_count = 19

pub const ability_layer_base = u16(1)

pub struct AbilitiesLayer {
pub mut:
	layer_id            u16
	set_abilities       u32
	set_ability_values  u32
	fly_speed           f32
	vertical_fly_speed  f32
	walk_speed          f32
}

pub struct AbilitiesData {
pub mut:
	target_actor_unique_id i64
	player_permission      u8
	command_permission     u8
	layers                 []AbilitiesLayer
}

pub struct UpdateAbilitiesPacket {
pub mut:
	data AbilitiesData
}

pub fn (p &UpdateAbilitiesPacket) pid() u16 {
	return update_abilities_packet
}

pub fn (p &UpdateAbilitiesPacket) name() string {
	return 'UpdateAbilitiesPacket'
}

pub fn (p &UpdateAbilitiesPacket) can_be_sent_before_login() bool {
	return false
}

fn read_abilities_data(mut r Reader) !AbilitiesData {
	mut d := AbilitiesData{
		target_actor_unique_id: i64(r.le_u64()!)
		player_permission:      r.u8()!
		command_permission:     r.u8()!
	}
	count := r.u8()!
	d.layers = []AbilitiesLayer{}
	for _ in 0 .. count {
		d.layers << AbilitiesLayer{
			layer_id:           r.le_u16()!
			set_abilities:      r.le_u32()!
			set_ability_values: r.le_u32()!
			fly_speed:          r.le_f32()!
			vertical_fly_speed: r.le_f32()!
			walk_speed:         r.le_f32()!
		}
	}
	return d
}

fn write_abilities_data(mut w Writer, d AbilitiesData) {
	w.le_u64(u64(d.target_actor_unique_id))
	w.u8(d.player_permission)
	w.u8(d.command_permission)
	w.u8(u8(d.layers.len))
	for l in d.layers {
		w.le_u16(l.layer_id)
		w.le_u32(l.set_abilities)
		w.le_u32(l.set_ability_values)
		w.le_f32(l.fly_speed)
		w.le_f32(l.vertical_fly_speed)
		w.le_f32(l.walk_speed)
	}
}

pub fn (mut p UpdateAbilitiesPacket) decode_payload(mut r Reader) ! {
	p.data = read_abilities_data(mut r)!
}

pub fn (p &UpdateAbilitiesPacket) encode_payload(mut w Writer) {
	write_abilities_data(mut w, p.data)
}
