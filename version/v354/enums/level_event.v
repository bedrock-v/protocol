module enums

import protocol.serializer

pub enum LevelEvent as i32 {
	undefined                        = 0
	sound_click                      = 1000
	sound_click_fail                 = 1001
	sound_launch                     = 1002
	sound_door_open                  = 1003
	sound_fizz                       = 1004
	sound_fuse                       = 1005
	sound_play_recording             = 1006
	sound_ghast_warning              = 1007
	sound_ghast_fireball             = 1008
	sound_blaze_fireball             = 1009
	sound_zombie_door_bump           = 1010
	sound_zombie_door_crash          = 1012
	sound_zombie_infected            = 1016
	sound_zombie_converted           = 1017
	sound_enderman_teleport          = 1018
	sound_anvil_broken               = 1020
	sound_anvil_used                 = 1021
	sound_anvil_land                 = 1022
	sound_infinity_arrow_pickup      = 1030
	sound_teleport_enderpearl        = 1032
	sound_itemframe_item_add         = 1040
	sound_itemframe_break            = 1041
	sound_itemframe_place            = 1042
	sound_itemframe_item_remove      = 1043
	sound_itemframe_item_rotate      = 1044
	sound_experience_orb_pickup      = 1051
	sound_totem_used                 = 1052
	sound_armor_stand_break          = 1060
	sound_armor_stand_hit            = 1061
	sound_armor_stand_land           = 1062
	sound_armor_stand_place          = 1063
	particle_shoot                   = 2000
	particle_destroy_block           = 2001
	particle_potion_splash           = 2002
	particle_eye_of_ender_death      = 2003
	particle_mob_block_spawn         = 2004
	particle_crop_growth             = 2005
	particle_sound_guardian_ghost    = 2006
	particle_death_smoke             = 2007
	particle_deny_block              = 2008
	particle_generic_spawn           = 2009
	particle_dragon_egg              = 2010
	particle_crop_eaten              = 2011
	particle_crit                    = 2012
	particle_teleport                = 2013
	particle_crack_block             = 2014
	particle_bubbles                 = 2015
	particle_evaporate               = 2016
	particle_destroy_armor_stand     = 2017
	particle_breaking_egg            = 2018
	particle_destroy_egg             = 2019
	particle_evaporate_water         = 2020
	particle_destroy_block_no_sound  = 2021
	particle_knockback_roar          = 2022
	start_raining                    = 3001
	start_thunderstorm               = 3002
	stop_raining                     = 3003
	stop_thunderstorm                = 3004
	global_pause                     = 3005
	sim_time_step                    = 3006
	sim_time_scale                   = 3007
	activate_block                   = 3500
	cauldron_explode                 = 3501
	cauldron_dye_armor               = 3502
	cauldron_clean_armor             = 3503
	cauldron_fill_potion             = 3504
	cauldron_take_potion             = 3505
	cauldron_fill_water              = 3506
	cauldron_take_water              = 3507
	cauldron_add_dye                 = 3508
	cauldron_clean_banner            = 3509
	cauldron_flush                   = 3510
	agent_spawn_effect               = 3511
	cauldron_fill_lava               = 3512
	cauldron_take_lava               = 3513
	particle_undefined               = 16384
	particle_bubble                  = 16385
	particle_type_crit               = 16386
	particle_block_force_field       = 16387
	particle_smoke                   = 16388
	particle_explode                 = 16389
	particle_evaporation             = 16390
	particle_flame                   = 16391
	particle_lava                    = 16392
	particle_large_smoke             = 16393
	particle_red_dust                = 16394
	particle_rising_border_dust      = 16395
	particle_icon_crack              = 16396
	particle_snowball_poof           = 16397
	particle_large_explode           = 16398
	particle_huge_explosion          = 16399
	particle_mob_flame               = 16400
	particle_heart                   = 16401
	particle_terrain                 = 16402
	particle_town_aura               = 16403
	particle_portal                  = 16404
	particle_water_splash            = 16405
	particle_water_wake              = 16406
	particle_drip_water              = 16407
	particle_drip_lava               = 16408
	particle_falling_dust            = 16409
	particle_mob_spell               = 16410
	particle_mob_spell_ambient       = 16411
	particle_mob_spell_instantaneous = 16412
	particle_ink                     = 16413
	particle_slime                   = 16414
	particle_rain_splash             = 16415
	particle_villager_angry          = 16416
	particle_villager_happy          = 16417
	particle_enchanting_table        = 16418
	particle_tracker_emitter         = 16419
	particle_note                    = 16420
	particle_witch_spell             = 16421
	particle_carrot_boost            = 16422
	particle_mob_appearance          = 16423
	particle_end_rod                 = 16424
	particle_dragon_breath           = 16425
	particle_spit                    = 16426
	particle_totem                   = 16427
	particle_food                    = 16428
	particle_fireworks_starter       = 16429
	particle_fireworks               = 16430
	particle_fireworks_overlay       = 16431
	particle_balloon_gas             = 16432
	particle_colored_flame           = 16433
	particle_sparkler                = 16434
	particle_conduit                 = 16435
	particle_bubble_column_up        = 16436
	particle_bubble_column_down      = 16437
	particle_sneeze                  = 16438
}

pub fn (e LevelEvent) encode(mut w serializer.Writer) {
	w.write_varint32(i32(e))
}

pub fn LevelEvent.decode(mut r serializer.Reader) !LevelEvent {
	return unsafe { LevelEvent(r.read_varint32()!) }
}
