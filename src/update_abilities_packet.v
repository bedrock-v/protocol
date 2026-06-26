module src

import src.serializer

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

fn read_abilities_data(mut r serializer.Reader) !AbilitiesData {
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

fn write_abilities_data(mut w serializer.Writer, d AbilitiesData) {
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

pub fn (mut p UpdateAbilitiesPacket) decode_payload(mut r serializer.Reader) ! {
	p.data = read_abilities_data(mut r)!
}

pub fn (p &UpdateAbilitiesPacket) encode_payload(mut w serializer.Writer) {
	write_abilities_data(mut w, p.data)
}
