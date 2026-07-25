module enums

import serializer

pub enum EntityEventType as u8 {
	@none                             = 0
	jump                              = 1
	hurt                              = 2
	death                             = 3
	attack_start                      = 4
	attack_stop                       = 5
	tame_failed                       = 6
	tame_succeeded                    = 7
	shake_wetness                     = 8
	use_item                          = 9
	eat_grass                         = 10
	fish_hook_bubble                  = 11
	fish_hook_position                = 12
	fish_hook_time                    = 13
	fish_hook_tease                   = 14
	squid_fleeing                     = 15
	zombie_villager_cure              = 16
	play_ambient                      = 17
	respawn                           = 18
	golem_flower_offer                = 19
	golem_flower_withdraw             = 20
	love_particles                    = 21
	villager_angry                    = 22
	villager_happy                    = 23
	witch_hat_magic                   = 24
	firework_explode                  = 25
	in_love_hearts                    = 26
	silverfish_merge_with_stone       = 27
	guardian_attack_animation         = 28
	witch_drink_potion                = 29
	witch_throw_potion                = 30
	prime_tnt_minecart                = 31
	prime_creeper                     = 32
	air_supply                        = 33
	player_add_xp_levels              = 34
	elder_guardian_curse              = 35
	agent_arm_swing                   = 36
	ender_dragon_death                = 37
	dust_particles                    = 38
	arrow_shake                       = 39
	eating_item                       = 57
	baby_animal_feed                  = 60
	death_smoke_cloud                 = 61
	complete_trade                    = 62
	remove_leash                      = 63
	caravan                           = 64
	consume_totem                     = 65
	check_treasure_hunter_achievement = 66
	entity_spawn                      = 67
	dragon_flaming                    = 68
	update_item_stack_size            = 69
	start_swimming                    = 70
	balloon_pop                       = 71
	treasure_hunt                     = 72
	summon_agent                      = 73
}

pub fn (e EntityEventType) encode(mut w serializer.Writer) {
	w.u8(u8(e))
}

pub fn EntityEventType.decode(mut r serializer.Reader) !EntityEventType {
	return unsafe { EntityEventType(r.u8()!) }
}
