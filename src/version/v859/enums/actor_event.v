module enums

import serializer

pub enum ActorEvent as i8 {
	@none                    = 0
	jump                     = 1
	hurt                     = 2
	death                    = 3
	start_attacking          = 4
	stop_attacking           = 5
	taming_failed            = 6
	taming_succeeded         = 7
	shake_wetness            = 8
	eat_grass                = 10
	fishhook_bubble          = 11
	fishhook_fishpos         = 12
	fishhook_hooktime        = 13
	fishhook_tease           = 14
	squid_fleeing            = 15
	zombie_converting        = 16
	play_ambient             = 17
	spawn_alive              = 18
	start_offer_flower       = 19
	stop_offer_flower        = 20
	love_hearts              = 21
	villager_angry           = 22
	villager_happy           = 23
	witch_hat_magic          = 24
	fireworks_explode        = 25
	in_love_hearts           = 26
	silverfish_merge_anim    = 27
	guardian_attack_sound    = 28
	drink_potion             = 29
	throw_potion             = 30
	prime_tntcart            = 31
	prime_creeper            = 32
	air_supply               = 33
	add_player_levels        = 34
	guardian_mining_fatigue  = 35
	agent_swing_arm          = 36
	dragon_start_death_anim  = 37
	ground_dust              = 38
	shake                    = 39
	feed                     = 57
	baby_age                 = 60
	instant_death            = 61
	notify_trade             = 62
	leash_destroyed          = 63
	caravan_updated          = 64
	talisman_activate        = 65
	update_structure_feature = 66
	player_spawned_mob       = 67
	puke                     = 68
	update_stack_size        = 69
	start_swimming           = 70
	balloon_pop              = 71
	treasure_hunt            = 72
	summon_agent             = 73
	finished_charging_item   = 74
	actor_grow_up            = 76
	vibration_detected       = 77
	drink_milk               = 78
	shake_wetness_stop       = 79
}

pub fn (e ActorEvent) encode(mut w serializer.Writer) {
	w.i8(i8(e))
}

pub fn ActorEvent.decode(mut r serializer.Reader) !ActorEvent {
	return unsafe { ActorEvent(r.i8()!) }
}
