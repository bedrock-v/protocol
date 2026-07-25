module types

import serializer
import version.v534.enums
import version.v291.enums as enums_291

pub enum AbilityLayerType as u16 {
	cache          = 0
	base           = 1
	spectator      = 2
	commands       = 3
	editor         = 4
	loading_screen = 5
}

pub fn get_abilities_number(abilities []enums.Ability) u32 {
	mut number := u32(0)
	for ability in abilities {
		number |= u32(1) << u32(ability)
	}
	return number
}

pub fn read_abilities_from_number(number u32) []enums.Ability {
	mut abilities := []enums.Ability{}
	for i in 0 .. 18 {
		if number & (u32(1) << u32(i)) != 0 {
			abilities << unsafe { enums.Ability(i) }
		}
	}
	return abilities
}

pub struct AbilityLayer {
pub mut:
	layer_type     AbilityLayerType
	abilities_set  []enums.Ability
	ability_values []enums.Ability
	fly_speed      f32
	walk_speed     f32
}

pub fn (t AbilityLayer) encode(mut w serializer.Writer) {
	w.le_u16(u16(t.layer_type))
	w.le_u32(get_abilities_number(t.abilities_set))
	w.le_u32(get_abilities_number(t.ability_values))
	w.le_f32(t.fly_speed)
	w.le_f32(t.walk_speed)
}

pub fn AbilityLayer.decode(mut r serializer.Reader) !AbilityLayer {
	return AbilityLayer{
		layer_type:     unsafe { AbilityLayerType(r.le_u16()!) }
		abilities_set:  read_abilities_from_number(r.le_u32()!)
		ability_values: read_abilities_from_number(r.le_u32()!)
		fly_speed:      r.le_f32()!
		walk_speed:     r.le_f32()!
	}
}

pub struct PlayerAbilitiesData {
pub mut:
	unique_entity_id   i64
	player_permission  enums_291.PlayerPermission
	command_permission enums_291.CommandPermission
	layers             []AbilityLayer
}

pub fn (t PlayerAbilitiesData) encode(mut w serializer.Writer) {
	w.le_i64(t.unique_entity_id)
	w.u8(u8(t.player_permission))
	t.command_permission.encode(mut w)
	w.write_varuint32(u32(t.layers.len))
	for layer in t.layers {
		layer.encode(mut w)
	}
}

pub fn PlayerAbilitiesData.decode(mut r serializer.Reader) !PlayerAbilitiesData {
	mut t := PlayerAbilitiesData{}
	t.unique_entity_id = r.le_i64()!
	t.player_permission = unsafe { enums_291.PlayerPermission(u32(r.u8()!)) }
	t.command_permission = enums_291.CommandPermission.decode(mut r)!
	layer_count := int(r.read_varuint32()!)
	t.layers = []AbilityLayer{cap: layer_count}
	for _ in 0 .. layer_count {
		t.layers << AbilityLayer.decode(mut r)!
	}
	return t
}
