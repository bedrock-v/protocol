module enums

import protocol.serializer

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
	mob_flame               = 18
	heart                   = 19
	terrain                 = 20
	town_aura               = 21
	portal                  = 22
	mob_portal              = 23
	water_splash            = 24
	water_splash_manual     = 25
	water_wake              = 26
	drip_water              = 27
	drip_lava               = 28
	drip_honey              = 29
	stalactite_drip_water   = 30
	stalactite_drip_lava    = 31
	falling_dust            = 32
	mob_spell               = 33
	mob_spell_ambient       = 34
	mob_spell_instantaneous = 35
	ink                     = 36
	slime                   = 37
	rain_splash             = 38
	villager_angry          = 39
	villager_happy          = 40
	enchanting_table        = 41
	tracker_emitter         = 42
	note                    = 43
	witch_spell             = 44
	carrot_boost            = 45
	mob_appearance          = 46
	end_rod                 = 47
	dragon_breath           = 48
	spit                    = 49
	totem                   = 50
	food                    = 51
	fireworks_starter       = 52
	fireworks               = 53
	fireworks_overlay       = 54
	balloon_gas             = 55
	colored_flame           = 56
	sparkler                = 57
	conduit                 = 58
	bubble_column_up        = 59
	bubble_column_down      = 60
	sneeze                  = 61
	shulker_bullet          = 62
	bleach                  = 63
	dragon_destroy_block    = 64
	mycelium_dust           = 65
	falling_border_dust     = 66
	campfire_smoke          = 67
	campfire_smoke_tall     = 68
	dragon_breath_fire      = 69
	dragon_breath_trail     = 70
	blue_flame              = 71
	soul                    = 72
	obsidian_tear           = 73
	portal_reverse          = 74
	snowflake               = 75
	vibration_signal        = 76
	sculk_sensor_redstone   = 77
	spore_blossom_shower    = 78
	spore_blossom_ambient   = 79
	wax                     = 80
	electric_spark          = 81
}

pub fn (e ParticleType) encode(mut w serializer.Writer) {
	w.write_varuint32(u32(e))
}

pub fn ParticleType.decode(mut r serializer.Reader) !ParticleType {
	return unsafe { ParticleType(r.read_varuint32()!) }
}
