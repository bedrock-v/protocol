module packets

import protocol.serializer
import protocol.version.v662.types
import protocol.version.v662.enums

pub enum AgentResult as i32 {
	action_fail        = 0
	action_success     = 1
	query_result_false = 2
	query_result_true  = 3
}

pub struct LegacyEventAchievement {
pub mut:
	achievement_id i32
}

pub struct LegacyEventInteraction {
pub mut:
	interacted_entity_id      types.ActorRuntimeID
	interaction_type          enums.InteractionType
	interaction_actor_type    enums.ActorType
	interaction_actor_variant i32
	interaction_actor_color   i8
}

pub struct LegacyEventPortalCreated {
pub mut:
	dimension_id i32
}

pub struct LegacyEventPortalUsed {
pub mut:
	source_dimension_id i32
	target_dimension_id i32
}

pub struct LegacyEventMobKilled {
pub mut:
	instigator_actor_id         i64
	target_actor_id             i64
	instigator_child_actor_type enums.ActorType
	damage_source               enums.ActorDamageCause
	trade_tier                  i32
	trader_name                 string
}

pub struct LegacyEventCauldronUsed {
pub mut:
	contents_color u32
	contents_type  i32
	fill_level     i32
}

pub struct LegacyEventPlayerDied {
pub mut:
	instigator_actor_id    i32
	instigator_mob_variant i32
	damage_source          enums.ActorDamageCause
	died_in_raid           bool
}

pub struct LegacyEventBossKilled {
pub mut:
	boss_actor_id i64
	party_size    i32
	boss_type     enums.ActorType
}

pub struct LegacyEventAgentCommandObsolete {
pub mut:
	result        AgentResult
	result_number i32
	command_name  string
	result_key    string
	result_string string
}

pub struct LegacyEventAgentCreated {
}

pub struct LegacyEventPatternRemovedObsolete {
}

pub struct LegacyEventSlashCommand {
pub mut:
	success_count i32
	error_count   i32
	command_name  string
	error_list    string
}

pub struct LegacyEventFishBucketed {
}

pub struct LegacyEventMobBorn {
pub mut:
	baby_entity_type    i32
	baby_entity_variant i32
	baby_color          i8
}

pub struct LegacyEventPetDiedObsolete {
}

pub struct LegacyEventPOICauldronUsed {
pub mut:
	block_interaction_type enums.POIBlockInteractionType
	item_id                i32
}

pub struct LegacyEventComposterUsed {
pub mut:
	block_interaction_type enums.POIBlockInteractionType
	item_id                i32
}

pub struct LegacyEventBellUsed {
pub mut:
	item_id i32
}

pub struct LegacyEventActorDefinition {
pub mut:
	event_name string
}

pub struct LegacyEventRaidUpdate {
pub mut:
	current_raid_wave i32
	total_raid_waves  i32
	raid_won          bool
}

pub struct LegacyEventPlayerMovementAnomalyObsolete {
}

pub struct LegacyEventPlayerMovementCorrectedObsolete {
}

pub struct LegacyEventHoneyHarvested {
}

pub struct LegacyEventTargetBlockHit {
pub mut:
	redstone_level i32
}

pub struct LegacyEventPiglinBarter {
pub mut:
	item_id               i32
	bartering_with_player bool
}

pub struct LegacyEventPlayerWaxedOrUnwaxedCopper {
pub mut:
	block_id i32
}

pub struct LegacyEventCodeBuilderRuntimeAction {
pub mut:
	runtime_action string
}

pub struct LegacyEventCodeBuilderScoreboard {
pub mut:
	objective_name string
	score          i32
}

pub struct LegacyEventStriderRiddenInLavaInOverworld {
}

pub struct LegacyEventSneakCloseToSculkSensor {
}

pub struct LegacyEventCarefulRestoration {
}

pub struct LegacyEventItemUsed {
pub mut:
	item_id    i16
	item_aux   i32
	use_method i32
	use_count  i32
}

pub type LegacyTelemetryEventType = LegacyEventAchievement
	| LegacyEventActorDefinition
	| LegacyEventAgentCommandObsolete
	| LegacyEventAgentCreated
	| LegacyEventBellUsed
	| LegacyEventBossKilled
	| LegacyEventCarefulRestoration
	| LegacyEventCauldronUsed
	| LegacyEventCodeBuilderRuntimeAction
	| LegacyEventCodeBuilderScoreboard
	| LegacyEventComposterUsed
	| LegacyEventFishBucketed
	| LegacyEventHoneyHarvested
	| LegacyEventInteraction
	| LegacyEventItemUsed
	| LegacyEventMobBorn
	| LegacyEventMobKilled
	| LegacyEventPOICauldronUsed
	| LegacyEventPatternRemovedObsolete
	| LegacyEventPetDiedObsolete
	| LegacyEventPiglinBarter
	| LegacyEventPlayerDied
	| LegacyEventPlayerMovementAnomalyObsolete
	| LegacyEventPlayerMovementCorrectedObsolete
	| LegacyEventPlayerWaxedOrUnwaxedCopper
	| LegacyEventPortalCreated
	| LegacyEventPortalUsed
	| LegacyEventRaidUpdate
	| LegacyEventSlashCommand
	| LegacyEventSneakCloseToSculkSensor
	| LegacyEventStriderRiddenInLavaInOverworld
	| LegacyEventTargetBlockHit

pub fn (t LegacyTelemetryEventType) id() i32 {
	return match t {
		LegacyEventAchievement { i32(0) }
		LegacyEventInteraction { i32(1) }
		LegacyEventPortalCreated { i32(2) }
		LegacyEventPortalUsed { i32(3) }
		LegacyEventMobKilled { i32(4) }
		LegacyEventCauldronUsed { i32(5) }
		LegacyEventPlayerDied { i32(6) }
		LegacyEventBossKilled { i32(7) }
		LegacyEventAgentCommandObsolete { i32(8) }
		LegacyEventAgentCreated { i32(9) }
		LegacyEventPatternRemovedObsolete { i32(10) }
		LegacyEventSlashCommand { i32(11) }
		LegacyEventFishBucketed { i32(12) }
		LegacyEventMobBorn { i32(13) }
		LegacyEventPetDiedObsolete { i32(14) }
		LegacyEventPOICauldronUsed { i32(15) }
		LegacyEventComposterUsed { i32(16) }
		LegacyEventBellUsed { i32(17) }
		LegacyEventActorDefinition { i32(18) }
		LegacyEventRaidUpdate { i32(19) }
		LegacyEventPlayerMovementAnomalyObsolete { i32(20) }
		LegacyEventPlayerMovementCorrectedObsolete { i32(21) }
		LegacyEventHoneyHarvested { i32(22) }
		LegacyEventTargetBlockHit { i32(23) }
		LegacyEventPiglinBarter { i32(24) }
		LegacyEventPlayerWaxedOrUnwaxedCopper { i32(25) }
		LegacyEventCodeBuilderRuntimeAction { i32(26) }
		LegacyEventCodeBuilderScoreboard { i32(27) }
		LegacyEventStriderRiddenInLavaInOverworld { i32(28) }
		LegacyEventSneakCloseToSculkSensor { i32(29) }
		LegacyEventCarefulRestoration { i32(30) }
		LegacyEventItemUsed { i32(31) }
	}
}

pub fn (t LegacyTelemetryEventType) payload_type() u32 {
	return match t {
		LegacyEventAchievement { u32(0) }
		LegacyEventInteraction { u32(1) }
		LegacyEventPortalCreated { u32(2) }
		LegacyEventPortalUsed { u32(3) }
		LegacyEventMobKilled { u32(4) }
		LegacyEventCauldronUsed { u32(5) }
		LegacyEventPlayerDied { u32(6) }
		LegacyEventBossKilled { u32(7) }
		LegacyEventSlashCommand { u32(8) }
		LegacyEventMobBorn { u32(9) }
		LegacyEventPOICauldronUsed { u32(10) }
		LegacyEventComposterUsed { u32(11) }
		LegacyEventBellUsed { u32(12) }
		LegacyEventActorDefinition { u32(13) }
		LegacyEventRaidUpdate { u32(14) }
		LegacyEventTargetBlockHit { u32(15) }
		LegacyEventPiglinBarter { u32(16) }
		LegacyEventPlayerWaxedOrUnwaxedCopper { u32(17) }
		LegacyEventCodeBuilderRuntimeAction { u32(18) }
		LegacyEventCodeBuilderScoreboard { u32(19) }
		LegacyEventItemUsed { u32(20) }
		else { u32(0) }
	}
}

pub fn (t LegacyTelemetryEventType) encode_payload(mut w serializer.Writer) {
	match t {
		LegacyEventAchievement {
			w.write_varint32(t.achievement_id)
		}
		LegacyEventInteraction {
			t.interacted_entity_id.encode(mut w)
			t.interaction_type.encode(mut w)
			t.interaction_actor_type.encode(mut w)
			w.write_varint32(t.interaction_actor_variant)
			w.i8(t.interaction_actor_color)
		}
		LegacyEventPortalCreated {
			w.write_varint32(t.dimension_id)
		}
		LegacyEventPortalUsed {
			w.write_varint32(t.source_dimension_id)
			w.write_varint32(t.target_dimension_id)
		}
		LegacyEventMobKilled {
			w.write_varint64(t.instigator_actor_id)
			w.write_varint64(t.target_actor_id)
			t.instigator_child_actor_type.encode(mut w)
			t.damage_source.encode(mut w)
			w.write_varint32(t.trade_tier)
			w.write_string(t.trader_name)
		}
		LegacyEventCauldronUsed {
			w.write_varuint32(t.contents_color)
			w.write_varint32(t.contents_type)
			w.write_varint32(t.fill_level)
		}
		LegacyEventPlayerDied {
			w.write_varint32(t.instigator_actor_id)
			w.write_varint32(t.instigator_mob_variant)
			t.damage_source.encode(mut w)
			w.bool(t.died_in_raid)
		}
		LegacyEventBossKilled {
			w.write_varint64(t.boss_actor_id)
			w.write_varint32(t.party_size)
			t.boss_type.encode(mut w)
		}
		LegacyEventAgentCommandObsolete {
			w.write_varint32(i32(t.result))
			w.write_varint32(t.result_number)
			w.write_string(t.command_name)
			w.write_string(t.result_key)
			w.write_string(t.result_string)
		}
		LegacyEventAgentCreated {}
		LegacyEventPatternRemovedObsolete {}
		LegacyEventSlashCommand {
			w.write_varint32(t.success_count)
			w.write_varint32(t.error_count)
			w.write_string(t.command_name)
			w.write_string(t.error_list)
		}
		LegacyEventFishBucketed {}
		LegacyEventMobBorn {
			w.write_varint32(t.baby_entity_type)
			w.write_varint32(t.baby_entity_variant)
			w.i8(t.baby_color)
		}
		LegacyEventPetDiedObsolete {}
		LegacyEventPOICauldronUsed {
			t.block_interaction_type.encode(mut w)
			w.write_varint32(t.item_id)
		}
		LegacyEventComposterUsed {
			t.block_interaction_type.encode(mut w)
			w.write_varint32(t.item_id)
		}
		LegacyEventBellUsed {
			w.write_varint32(t.item_id)
		}
		LegacyEventActorDefinition {
			w.write_string(t.event_name)
		}
		LegacyEventRaidUpdate {
			w.write_varint32(t.current_raid_wave)
			w.write_varint32(t.total_raid_waves)
			w.bool(t.raid_won)
		}
		LegacyEventPlayerMovementAnomalyObsolete {}
		LegacyEventPlayerMovementCorrectedObsolete {}
		LegacyEventHoneyHarvested {}
		LegacyEventTargetBlockHit {
			w.write_varint32(t.redstone_level)
		}
		LegacyEventPiglinBarter {
			w.write_varint32(t.item_id)
			w.bool(t.bartering_with_player)
		}
		LegacyEventPlayerWaxedOrUnwaxedCopper {
			w.write_varint32(t.block_id)
		}
		LegacyEventCodeBuilderRuntimeAction {
			w.write_string(t.runtime_action)
		}
		LegacyEventCodeBuilderScoreboard {
			w.write_string(t.objective_name)
			w.write_varint32(t.score)
		}
		LegacyEventStriderRiddenInLavaInOverworld {}
		LegacyEventSneakCloseToSculkSensor {}
		LegacyEventCarefulRestoration {}
		LegacyEventItemUsed {
			w.le_i16(t.item_id)
			w.le_i32(t.item_aux)
			w.le_i32(t.use_method)
			w.le_i32(t.use_count)
		}
	}
}

pub fn LegacyTelemetryEventType.decode_payload(id i32, mut r serializer.Reader) !LegacyTelemetryEventType {
	match id {
		0 {
			return LegacyEventAchievement{
				achievement_id: r.read_varint32()!
			}
		}
		1 {
			return LegacyEventInteraction{
				interacted_entity_id:      types.ActorRuntimeID.decode(mut r)!
				interaction_type:          enums.InteractionType.decode(mut r)!
				interaction_actor_type:    enums.ActorType.decode(mut r)!
				interaction_actor_variant: r.read_varint32()!
				interaction_actor_color:   r.i8()!
			}
		}
		2 {
			return LegacyEventPortalCreated{
				dimension_id: r.read_varint32()!
			}
		}
		3 {
			return LegacyEventPortalUsed{
				source_dimension_id: r.read_varint32()!
				target_dimension_id: r.read_varint32()!
			}
		}
		4 {
			return LegacyEventMobKilled{
				instigator_actor_id:         r.read_varint64()!
				target_actor_id:             r.read_varint64()!
				instigator_child_actor_type: enums.ActorType.decode(mut r)!
				damage_source:               enums.ActorDamageCause.decode(mut r)!
				trade_tier:                  r.read_varint32()!
				trader_name:                 r.read_string()!
			}
		}
		5 {
			return LegacyEventCauldronUsed{
				contents_color: r.read_varuint32()!
				contents_type:  r.read_varint32()!
				fill_level:     r.read_varint32()!
			}
		}
		6 {
			return LegacyEventPlayerDied{
				instigator_actor_id:    r.read_varint32()!
				instigator_mob_variant: r.read_varint32()!
				damage_source:          enums.ActorDamageCause.decode(mut r)!
				died_in_raid:           r.bool()!
			}
		}
		7 {
			return LegacyEventBossKilled{
				boss_actor_id: r.read_varint64()!
				party_size:    r.read_varint32()!
				boss_type:     enums.ActorType.decode(mut r)!
			}
		}
		8 {
			return LegacyEventAgentCommandObsolete{
				result:        unsafe { AgentResult(r.read_varint32()!) }
				result_number: r.read_varint32()!
				command_name:  r.read_string()!
				result_key:    r.read_string()!
				result_string: r.read_string()!
			}
		}
		9 {
			return LegacyEventAgentCreated{}
		}
		10 {
			return LegacyEventPatternRemovedObsolete{}
		}
		11 {
			return LegacyEventSlashCommand{
				success_count: r.read_varint32()!
				error_count:   r.read_varint32()!
				command_name:  r.read_string()!
				error_list:    r.read_string()!
			}
		}
		12 {
			return LegacyEventFishBucketed{}
		}
		13 {
			return LegacyEventMobBorn{
				baby_entity_type:    r.read_varint32()!
				baby_entity_variant: r.read_varint32()!
				baby_color:          r.i8()!
			}
		}
		14 {
			return LegacyEventPetDiedObsolete{}
		}
		15 {
			return LegacyEventPOICauldronUsed{
				block_interaction_type: enums.POIBlockInteractionType.decode(mut r)!
				item_id:                r.read_varint32()!
			}
		}
		16 {
			return LegacyEventComposterUsed{
				block_interaction_type: enums.POIBlockInteractionType.decode(mut r)!
				item_id:                r.read_varint32()!
			}
		}
		17 {
			return LegacyEventBellUsed{
				item_id: r.read_varint32()!
			}
		}
		18 {
			return LegacyEventActorDefinition{
				event_name: r.read_string()!
			}
		}
		19 {
			return LegacyEventRaidUpdate{
				current_raid_wave: r.read_varint32()!
				total_raid_waves:  r.read_varint32()!
				raid_won:          r.bool()!
			}
		}
		20 {
			return LegacyEventPlayerMovementAnomalyObsolete{}
		}
		21 {
			return LegacyEventPlayerMovementCorrectedObsolete{}
		}
		22 {
			return LegacyEventHoneyHarvested{}
		}
		23 {
			return LegacyEventTargetBlockHit{
				redstone_level: r.read_varint32()!
			}
		}
		24 {
			return LegacyEventPiglinBarter{
				item_id:               r.read_varint32()!
				bartering_with_player: r.bool()!
			}
		}
		25 {
			return LegacyEventPlayerWaxedOrUnwaxedCopper{
				block_id: r.read_varint32()!
			}
		}
		26 {
			return LegacyEventCodeBuilderRuntimeAction{
				runtime_action: r.read_string()!
			}
		}
		27 {
			return LegacyEventCodeBuilderScoreboard{
				objective_name: r.read_string()!
				score:          r.read_varint32()!
			}
		}
		28 {
			return LegacyEventStriderRiddenInLavaInOverworld{}
		}
		29 {
			return LegacyEventSneakCloseToSculkSensor{}
		}
		30 {
			return LegacyEventCarefulRestoration{}
		}
		31 {
			return LegacyEventItemUsed{
				item_id:    r.le_i16()!
				item_aux:   r.le_i32()!
				use_method: r.le_i32()!
				use_count:  r.le_i32()!
			}
		}
		else {
			return error('invalid LegacyTelemetryEventType ${id}')
		}
	}
}

pub struct LegacyTelemetryEventPacket {
pub mut:
	target_actor_id types.ActorUniqueID
	event_type      LegacyTelemetryEventType = LegacyEventAchievement{}
	use_player_id   bool
}

pub fn (p &LegacyTelemetryEventPacket) pid() u16 {
	return 65
}

pub fn (p &LegacyTelemetryEventPacket) name() string {
	return 'LegacyTelemetryEventPacket'
}

pub fn (p &LegacyTelemetryEventPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &LegacyTelemetryEventPacket) encode_payload(mut w serializer.Writer) {
	p.target_actor_id.encode(mut w)
	w.write_varint32(p.event_type.id())
	w.bool(p.use_player_id)
	w.write_varuint32(p.event_type.payload_type())
	p.event_type.encode_payload(mut w)
}

pub fn (mut p LegacyTelemetryEventPacket) decode_payload(mut r serializer.Reader) ! {
	p.target_actor_id = types.ActorUniqueID.decode(mut r)!
	type_id := r.read_varint32()!
	p.use_player_id = r.bool()!
	r.read_varuint32()!
	p.event_type = LegacyTelemetryEventType.decode_payload(type_id, mut r)!
}
