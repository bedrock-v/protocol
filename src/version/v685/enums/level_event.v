module enums

import protocol.serializer

pub enum LevelEvent as i32 {
	_9800                                     = 3619
	undefined                                 = 0
	sound_click                               = 1000
	sound_click_fail                          = 1001
	sound_launch                              = 1002
	sound_open_door                           = 1003
	sound_fizz                                = 1004
	sound_fuse                                = 1005
	sound_play_recording                      = 1006
	sound_ghast_warning                       = 1007
	sound_ghast_fireball                      = 1008
	sound_blaze_fireball                      = 1009
	sound_zombie_wooden_door                  = 1010
	sound_zombie_door_crash                   = 1012
	sound_zombie_infected                     = 1016
	sound_zombie_converted                    = 1017
	sound_enderman_teleport                   = 1018
	sound_anvil_broken                        = 1020
	sound_anvil_used                          = 1021
	sound_anvil_land                          = 1022
	sound_infinity_arrow_pickup               = 1030
	sound_teleport_ender_pearl                = 1032
	sound_add_item                            = 1040
	sound_item_frame_break                    = 1041
	sound_item_frame_place                    = 1042
	sound_item_frame_remove_item              = 1043
	sound_item_frame_rotate_item              = 1044
	sound_experience_orb_pickup               = 1051
	sound_totem_used                          = 1052
	sound_armor_stand_break                   = 1060
	sound_armor_stand_hit                     = 1061
	sound_armor_stand_land                    = 1062
	sound_armor_stand_place                   = 1063
	sound_pointed_dripstone_land              = 1064
	sound_dye_used                            = 1065
	sound_ink_sac_used                        = 1066
	sound_amethyst_resonate                   = 1067
	queue_custom_music                        = 1900
	play_custom_music                         = 1901
	stop_custom_music                         = 1902
	set_music_volume                          = 1903
	particles_shoot                           = 2000
	particles_destroy_block                   = 2001
	particles_potion_splash                   = 2002
	particles_eye_of_ender_death              = 2003
	particles_mob_block_spawn                 = 2004
	particle_crop_growth                      = 2005
	particle_sound_guardian_ghost             = 2006
	particle_death_smoke                      = 2007
	particle_deny_block                       = 2008
	particle_generic_spawn                    = 2009
	particles_dragon_egg                      = 2010
	particles_crop_eaten                      = 2011
	particles_crit                            = 2012
	particles_teleport                        = 2013
	particles_crack_block                     = 2014
	particles_bubble                          = 2015
	particles_evaporate                       = 2016
	particles_destroy_armor_stand             = 2017
	particles_breaking_egg                    = 2018
	particle_destroy_egg                      = 2019
	particles_evaporate_water                 = 2020
	particles_destroy_block_no_sound          = 2021
	particles_knockback_roar                  = 2022
	particles_teleport_trail                  = 2023
	particles_point_cloud                     = 2024
	particles_explosion                       = 2025
	particles_block_explosion                 = 2026
	particles_vibration_signal                = 2027
	particles_dripstone_drip                  = 2028
	particles_fizz_effect                     = 2029
	wax_on                                    = 2030
	wax_off                                   = 2031
	scrape                                    = 2032
	particles_electric_spark                  = 2033
	particle_turtle_egg                       = 2034
	particles_sculk_shriek                    = 2035
	sculk_catalyst_bloom                      = 2036
	sculk_charge                              = 2037
	sculk_charge_pop                          = 2038
	sonic_explosion                           = 2039
	dust_plume                                = 2040
	start_raining                             = 3001
	start_thunderstorm                        = 3002
	stop_raining                              = 3003
	stop_thunderstorm                         = 3004
	global_pause                              = 3005
	sim_time_step                             = 3006
	sim_time_scale                            = 3007
	activate_block                            = 3500
	cauldron_explode                          = 3501
	cauldron_dye_armor                        = 3502
	cauldron_clean_armor                      = 3503
	cauldron_fill_potion                      = 3504
	cauldron_take_potion                      = 3505
	cauldron_fill_water                       = 3506
	cauldron_take_water                       = 3507
	cauldron_add_dye                          = 3508
	cauldron_clean_banner                     = 3509
	cauldron_flush                            = 3510
	agent_spawn_effect                        = 3511
	cauldron_fill_lava                        = 3512
	cauldron_take_lava                        = 3513
	cauldron_fill_powder_snow                 = 3514
	cauldron_take_powder_snow                 = 3515
	start_block_cracking                      = 3600
	stop_block_cracking                       = 3601
	update_block_cracking                     = 3602
	particles_crack_block_down                = 3603
	particles_crack_block_up                  = 3604
	particles_crack_block_north               = 3605
	particles_crack_block_south               = 3606
	particles_crack_block_west                = 3607
	particles_crack_block_east                = 3608
	particles_shoot_white_smoke               = 3609
	particles_breeze_wind_explosion           = 3610
	particles_trial_spawner_detection         = 3611
	particles_trial_spawner_spawning          = 3612
	particles_trial_spawner_ejecting          = 3613
	particles_wind_explosion                  = 3614
	particles_trial_spawner_detection_charged = 3615
	particles_trial_spawner_become_charged    = 3616
	all_players_sleeping                      = 3617
	deprecated                                = 3618
	sleeping_players                          = 9801
	jump_prevented                            = 9810
	animation_vault_activate                  = 9811
	animation_vault_deactivate                = 9812
	animation_vault_eject_item                = 9813
	animation_spawn_cobweb                    = 9814
	particle_smash_attack_ground_dust         = 9815
	particle_legacy_event                     = 0x4000
}

pub fn (e LevelEvent) encode(mut w serializer.Writer) {
	w.write_varint32(i32(e))
}

pub fn LevelEvent.decode(mut r serializer.Reader) !LevelEvent {
	return unsafe { LevelEvent(r.read_varint32()!) }
}
