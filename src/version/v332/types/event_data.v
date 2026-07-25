module types

import serializer

pub struct AchievementAwardedEventData {
pub mut:
	achievement_id i32
}

pub struct EntityInteractEventData {
pub mut:
	interaction_type      i32
	legacy_entity_type_id i32
	variant               i32
	palette_color         u8
}

pub struct PortalBuiltEventData {
pub mut:
	dimension_id i32
}

pub struct PortalUsedEventData {
pub mut:
	from_dimension_id i32
	to_dimension_id   i32
}

pub struct MobKilledEventData {
pub mut:
	killer_unique_entity_id i64
	victim_unique_entity_id i64
	entity_damage_cause     i32
	villager_trade_tier     i32
	villager_display_name   string
}

pub struct CauldronUsedEventData {
pub mut:
	potion_id  i32
	color      i32
	fill_level i32
}

pub struct PlayerDiedEventData {
pub mut:
	attacker_entity_id  i32
	entity_damage_cause i32
}

pub struct BossKilledEventData {
pub mut:
	boss_unique_entity_id i64
	player_party_size     i32
	boss_entity_type      i32
}

pub struct AgentCommandEventData {
pub mut:
	result     i32
	data_value i32
	command    string
	data_key   string
	output     string
}

pub struct AgentCreatedEventData {}

pub struct PatternRemovedEventData {
pub mut:
	item_id       i32
	aux_value     i32
	patterns_size i32
	pattern_index i32
	pattern_color i32
}

pub struct SlashCommandExecutedEventData {
pub mut:
	success_count   i32
	error_count     i32
	command_name    string
	output_messages []string
}

pub struct FishBucketedEventData {
pub mut:
	pattern              i32
	preset               i32
	bucketed_entity_type i32
	release_event        bool
}

pub struct MobBornEventData {
pub mut:
	entity_type i32
	variant     i32
	color       u8
}

pub struct PetDiedEventData {
pub mut:
	killed_by_owner         bool
	killer_unique_entity_id i64
	pet_unique_entity_id    i64
	entity_damage_cause     i32
}

pub type EventData = AchievementAwardedEventData
	| AgentCommandEventData
	| AgentCreatedEventData
	| BossKilledEventData
	| CauldronUsedEventData
	| EntityInteractEventData
	| FishBucketedEventData
	| MobBornEventData
	| MobKilledEventData
	| PatternRemovedEventData
	| PetDiedEventData
	| PlayerDiedEventData
	| PortalBuiltEventData
	| PortalUsedEventData
	| SlashCommandExecutedEventData

pub fn (t EventData) id() i32 {
	return match t {
		AchievementAwardedEventData { i32(0) }
		EntityInteractEventData { i32(1) }
		PortalBuiltEventData { i32(2) }
		PortalUsedEventData { i32(3) }
		MobKilledEventData { i32(4) }
		CauldronUsedEventData { i32(5) }
		PlayerDiedEventData { i32(6) }
		BossKilledEventData { i32(7) }
		AgentCommandEventData { i32(8) }
		AgentCreatedEventData { i32(9) }
		PatternRemovedEventData { i32(10) }
		SlashCommandExecutedEventData { i32(11) }
		FishBucketedEventData { i32(12) }
		MobBornEventData { i32(13) }
		PetDiedEventData { i32(14) }
	}
}

pub fn (t EventData) encode_payload(mut w serializer.Writer) {
	match t {
		AchievementAwardedEventData {
			w.write_varint32(t.achievement_id)
		}
		EntityInteractEventData {
			w.write_varint32(t.interaction_type)
			w.write_varint32(t.legacy_entity_type_id)
			w.write_varint32(t.variant)
			w.u8(t.palette_color)
		}
		PortalBuiltEventData {
			w.write_varint32(t.dimension_id)
		}
		PortalUsedEventData {
			w.write_varint32(t.from_dimension_id)
			w.write_varint32(t.to_dimension_id)
		}
		MobKilledEventData {
			w.write_varint64(t.killer_unique_entity_id)
			w.write_varint64(t.victim_unique_entity_id)
			w.write_varint32(t.entity_damage_cause)
			w.write_varint32(t.villager_trade_tier)
			w.write_string(t.villager_display_name)
		}
		CauldronUsedEventData {
			w.write_varuint32(u32(t.potion_id))
			w.write_varint32(t.color)
			w.write_varint32(t.fill_level)
		}
		PlayerDiedEventData {
			w.write_varint32(t.attacker_entity_id)
			w.write_varint32(t.entity_damage_cause)
		}
		BossKilledEventData {
			w.write_varint64(t.boss_unique_entity_id)
			w.write_varint32(t.player_party_size)
			w.write_varint32(t.boss_entity_type)
		}
		AgentCommandEventData {
			w.write_varint32(t.result)
			w.write_varint32(t.data_value)
			w.write_string(t.command)
			w.write_string(t.data_key)
			w.write_string(t.output)
		}
		AgentCreatedEventData {}
		PatternRemovedEventData {
			w.write_varint32(t.item_id)
			w.write_varint32(t.aux_value)
			w.write_varint32(t.patterns_size)
			w.write_varint32(t.pattern_index)
			w.write_varint32(t.pattern_color)
		}
		SlashCommandExecutedEventData {
			w.write_varint32(t.success_count)
			w.write_varint32(t.error_count)
			w.write_string(t.command_name)
			w.write_string(t.output_messages.join(';'))
		}
		FishBucketedEventData {
			w.write_varint32(t.pattern)
			w.write_varint32(t.preset)
			w.write_varint32(t.bucketed_entity_type)
			w.bool(t.release_event)
		}
		MobBornEventData {
			w.write_varint32(t.entity_type)
			w.write_varint32(t.variant)
			w.u8(t.color)
		}
		PetDiedEventData {
			w.bool(t.killed_by_owner)
			w.write_varint64(t.killer_unique_entity_id)
			w.write_varint64(t.pet_unique_entity_id)
			w.write_varint32(t.entity_damage_cause)
		}
	}
}

pub fn EventData.decode_payload(id i32, mut r serializer.Reader) !EventData {
	match id {
		0 {
			return AchievementAwardedEventData{
				achievement_id: r.read_varint32()!
			}
		}
		1 {
			return EntityInteractEventData{
				interaction_type:      r.read_varint32()!
				legacy_entity_type_id: r.read_varint32()!
				variant:               r.read_varint32()!
				palette_color:         r.u8()!
			}
		}
		2 {
			return PortalBuiltEventData{
				dimension_id: r.read_varint32()!
			}
		}
		3 {
			return PortalUsedEventData{
				from_dimension_id: r.read_varint32()!
				to_dimension_id:   r.read_varint32()!
			}
		}
		4 {
			return MobKilledEventData{
				killer_unique_entity_id: r.read_varint64()!
				victim_unique_entity_id: r.read_varint64()!
				entity_damage_cause:     r.read_varint32()!
				villager_trade_tier:     r.read_varint32()!
				villager_display_name:   r.read_string()!
			}
		}
		5 {
			return CauldronUsedEventData{
				potion_id:  r.read_varint32()!
				color:      r.read_varint32()!
				fill_level: r.read_varint32()!
			}
		}
		6 {
			return PlayerDiedEventData{
				attacker_entity_id:  r.read_varint32()!
				entity_damage_cause: r.read_varint32()!
			}
		}
		7 {
			return BossKilledEventData{
				boss_unique_entity_id: r.read_varint64()!
				player_party_size:     r.read_varint32()!
				boss_entity_type:      r.read_varint32()!
			}
		}
		8 {
			return AgentCommandEventData{
				result:     r.read_varint32()!
				data_value: r.read_varint32()!
				command:    r.read_string()!
				data_key:   r.read_string()!
				output:     r.read_string()!
			}
		}
		9 {
			return AgentCreatedEventData{}
		}
		10 {
			return PatternRemovedEventData{
				item_id:       r.read_varint32()!
				aux_value:     r.read_varint32()!
				patterns_size: r.read_varint32()!
				pattern_index: r.read_varint32()!
				pattern_color: r.read_varint32()!
			}
		}
		11 {
			mut t := SlashCommandExecutedEventData{}
			t.success_count = r.read_varint32()!
			t.error_count = r.read_varint32()!
			t.command_name = r.read_string()!
			t.output_messages = r.read_string()!.split(';')
			return t
		}
		12 {
			return FishBucketedEventData{
				pattern:              r.read_varint32()!
				preset:               r.read_varint32()!
				bucketed_entity_type: r.read_varint32()!
				release_event:        r.bool()!
			}
		}
		13 {
			return MobBornEventData{
				entity_type: r.read_varint32()!
				variant:     r.read_varint32()!
				color:       r.u8()!
			}
		}
		14 {
			return PetDiedEventData{
				killed_by_owner:         r.bool()!
				killer_unique_entity_id: r.read_varint64()!
				pet_unique_entity_id:    r.read_varint64()!
				entity_damage_cause:     r.read_varint32()!
			}
		}
		else {
			return error('invalid EventData type ${id}')
		}
	}
}
