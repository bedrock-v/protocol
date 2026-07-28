module types

import protocol.serializer
import protocol.version.v662.enums

pub struct SerializedLayer {
pub mut:
	serialized_layer enums.SerializedAbilitiesLayer
	abilities_set    u32
	ability_values   u32
	fly_speed        f32
	walk_speed       f32
}

pub fn (t SerializedLayer) encode(mut w serializer.Writer) {
	t.serialized_layer.encode(mut w)
	w.le_u32(t.abilities_set)
	w.le_u32(t.ability_values)
	w.le_f32(t.fly_speed)
	w.le_f32(t.walk_speed)
}

pub fn SerializedLayer.decode(mut r serializer.Reader) !SerializedLayer {
	return SerializedLayer{
		serialized_layer: enums.SerializedAbilitiesLayer.decode(mut r)!
		abilities_set:    r.le_u32()!
		ability_values:   r.le_u32()!
		fly_speed:        r.le_f32()!
		walk_speed:       r.le_f32()!
	}
}

pub struct SerializedAbilitiesData {
pub mut:
	target_player_raw_id i64
	player_permissions   enums.PlayerPermissionLevel
	command_permissions  enums.CommandPermissionLevel
	layers               []SerializedLayer
}

pub fn (t SerializedAbilitiesData) encode(mut w serializer.Writer) {
	w.le_i64(t.target_player_raw_id)
	t.player_permissions.encode(mut w)
	t.command_permissions.encode(mut w)
	w.write_varuint32(u32(t.layers.len))
	for e in t.layers {
		e.encode(mut w)
	}
}

pub fn SerializedAbilitiesData.decode(mut r serializer.Reader) !SerializedAbilitiesData {
	raw := r.le_i64()!
	pp := enums.PlayerPermissionLevel.decode(mut r)!
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
