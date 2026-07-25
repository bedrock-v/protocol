module enums

import serializer

pub enum ParticleType as u32 {
	undefined               = 0
	bubble                  = 1
	bubble_manual           = 2
	crit                    = 3
	block_force_field       = 4
	smoke                   = 5
	explode                 = 6
	evaporation             = 7
	flame                   = 8
	candle_flame            = 9
	lava                    = 10
	large_smoke             = 11
	red_dust                = 12
	rising_border_dust      = 13
	icon_crack              = 14
	snowball_poof           = 15
	large_explode           = 16
	huge_explosion          = 17
	breeze_wind_explosion   = 18
	mob_flame               = 19
	heart                   = 20
	terrain                 = 21
	town_aura               = 22
	portal                  = 23
	mob_portal              = 24
	water_splash            = 25
	water_splash_manual     = 26
	water_wake              = 27
	drip_water              = 28
	drip_lava               = 29
	drip_honey              = 30
	stalactite_drip_water   = 31
	stalactite_drip_lava    = 32
	falling_dust            = 33
	mob_spell               = 34
	mob_spell_ambient       = 35
	mob_spell_instantaneous = 36
	ink                     = 37
	slime                   = 38
	rain_splash             = 39
	villager_angry          = 40
	villager_happy          = 41
	enchanting_table        = 42
	tracking_emitter        = 43
	note                    = 44
	witch_spell             = 45
	carrot_boost            = 46
	mob_appearance          = 47
	end_rod                 = 48
	dragon_breath           = 49
	spit                    = 50
	totem                   = 51
	food                    = 52
	fireworks_starter       = 53
	fireworks               = 54
	fireworks_overlay       = 55
	balloon_gas             = 56
	colored_flame           = 57
	sparkler                = 58
	conduit                 = 59
	bubble_column_up        = 60
	bubble_column_down      = 61
	sneeze                  = 62
	shulker_bullet          = 63
	bleach                  = 64
	dragon_destroy_block    = 65
	mycelium_dust           = 66
	falling_border_dust     = 67
	campfire_smoke          = 68
	campfire_smoke_tall     = 69
	dragon_breath_fire      = 70
	dragon_breath_trail     = 71
	blue_flame              = 72
	soul                    = 73
	obsidian_tear           = 74
	portal_reverse          = 75
	snowflake               = 76
	vibration_signal        = 77
	sculk_sensor_redstone   = 78
	spore_blossom_shower    = 79
	spore_blossom_ambient   = 80
	wax                     = 81
	electric_spark          = 82
	shriek                  = 83
	sculk_soul              = 84
	sonic_explosion         = 85
	brush_dust              = 86
	cherry_leaves           = 87
	dust_plume              = 88
	white_smoke             = 89
	vault_connection        = 90
	wind_explosion          = 91
	wolf_armor_crack        = 92
	count                   = 93
}

pub fn (e ParticleType) encode(mut w serializer.Writer) {
	w.write_varuint32(u32(e))
}

pub fn ParticleType.decode(mut r serializer.Reader) !ParticleType {
	return unsafe { ParticleType(r.read_varuint32()!) }
}
