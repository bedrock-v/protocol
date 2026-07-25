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
	lava                    = 9
	large_smoke             = 10
	red_dust                = 11
	rising_border_dust      = 12
	icon_crack              = 13
	snowball_poof           = 14
	large_explode           = 15
	huge_explosion          = 16
	mob_flame               = 17
	heart                   = 18
	terrain                 = 19
	town_aura               = 20
	portal                  = 21
	mob_portal              = 22
	water_splash            = 23
	water_splash_manual     = 24
	water_wake              = 25
	drip_water              = 26
	drip_lava               = 27
	drip_honey              = 28
	stalactite_drip_water   = 29
	stalactite_drip_lava    = 30
	falling_dust            = 31
	mob_spell               = 32
	mob_spell_ambient       = 33
	mob_spell_instantaneous = 34
	ink                     = 35
	slime                   = 36
	rain_splash             = 37
	villager_angry          = 38
	villager_happy          = 39
	enchanting_table        = 40
	tracker_emitter         = 41
	note                    = 42
	witch_spell             = 43
	carrot_boost            = 44
	mob_appearance          = 45
	end_rod                 = 46
	dragon_breath           = 47
	spit                    = 48
	totem                   = 49
	food                    = 50
	fireworks_starter       = 51
	fireworks               = 52
	fireworks_overlay       = 53
	balloon_gas             = 54
	colored_flame           = 55
	sparkler                = 56
	conduit                 = 57
	bubble_column_up        = 58
	bubble_column_down      = 59
	sneeze                  = 60
	shulker_bullet          = 61
	bleach                  = 62
	dragon_destroy_block    = 63
	mycelium_dust           = 64
	falling_border_dust     = 65
	campfire_smoke          = 66
	campfire_smoke_tall     = 67
	dragon_breath_fire      = 68
	dragon_breath_trail     = 69
	blue_flame              = 70
	soul                    = 71
	obsidian_tear           = 72
}

pub fn (e ParticleType) encode(mut w serializer.Writer) {
	w.write_varuint32(u32(e))
}

pub fn ParticleType.decode(mut r serializer.Reader) !ParticleType {
	return unsafe { ParticleType(r.read_varuint32()!) }
}
