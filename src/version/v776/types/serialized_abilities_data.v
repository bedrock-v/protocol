module types

import serializer
import version.v662.enums

pub enum SerializedAbilitiesLayer as u16 {
	custom_cache = 0
	base         = 1
	spectator    = 2
	commands     = 3
	editor       = 4
}

pub fn (e SerializedAbilitiesLayer) encode(mut w serializer.Writer) {
	w.le_u16(u16(e))
}

pub fn SerializedAbilitiesLayer.decode(mut r serializer.Reader) !SerializedAbilitiesLayer {
	return unsafe { SerializedAbilitiesLayer(r.le_u16()!) }
}

pub struct SerializedLayer {
pub mut:
	serialized_layer   SerializedAbilitiesLayer
	abilities_set      u32
	ability_values     u32
	fly_speed          f32
	vertical_fly_speed f32
	walk_speed         f32
}

pub fn (t SerializedLayer) encode(mut w serializer.Writer) {
	t.serialized_layer.encode(mut w)
	w.le_u32(t.abilities_set)
	w.le_u32(t.ability_values)
	w.le_f32(t.fly_speed)
	w.le_f32(t.vertical_fly_speed)
	w.le_f32(t.walk_speed)
}

pub fn SerializedLayer.decode(mut r serializer.Reader) !SerializedLayer {
	return SerializedLayer{
		serialized_layer:   SerializedAbilitiesLayer.decode(mut r)!
		abilities_set:      r.le_u32()!
		ability_values:     r.le_u32()!
		fly_speed:          r.le_f32()!
		vertical_fly_speed: r.le_f32()!
		walk_speed:         r.le_f32()!
	}
}

pub struct SerializedAbilitiesData {
pub mut:
	target_player_raw_id i64
	player_permissions   u8
	command_permissions  enums.CommandPermissionLevel
	layers               []SerializedLayer
}

pub fn (t SerializedAbilitiesData) encode(mut w serializer.Writer) {
	w.le_i64(t.target_player_raw_id)
	w.u8(t.player_permissions)
	t.command_permissions.encode(mut w)
	w.write_varuint32(u32(t.layers.len))
	for e in t.layers {
		e.encode(mut w)
	}
}

pub fn SerializedAbilitiesData.decode(mut r serializer.Reader) !SerializedAbilitiesData {
	raw := r.le_i64()!
	pp := r.u8()!
	cp := enums.CommandPermissionLevel.decode(mut r)!
	count := int(r.read_varuint32()!)
	mut items := []SerializedLayer{cap: count}
	for _ in 0 .. count {
		items << SerializedLayer.decode(mut r)!
	}
	return SerializedAbilitiesData{
		target_player_raw_id: raw
		player_permissions:   pp
		command_permissions:  cp
		layers:               items
	}
}
