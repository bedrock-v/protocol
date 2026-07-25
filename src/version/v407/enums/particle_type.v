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
	falling_dust            = 29
	mob_spell               = 30
	mob_spell_ambient       = 31
	mob_spell_instantaneous = 32
	ink                     = 33
	slime                   = 34
	rain_splash             = 35
	villager_angry          = 36
	villager_happy          = 37
	enchanting_table        = 38
	tracker_emitter         = 39
	note                    = 40
	witch_spell             = 41
	carrot_boost            = 42
	mob_appearance          = 43
	end_rod                 = 44
	dragon_breath           = 45
	spit                    = 46
	totem                   = 47
	food                    = 48
	fireworks_starter       = 49
	fireworks               = 50
	fireworks_overlay       = 51
	balloon_gas             = 52
	colored_flame           = 53
	sparkler                = 54
	conduit                 = 55
	bubble_column_up        = 56
	bubble_column_down      = 57
	sneeze                  = 58
	shulker_bullet          = 59
	bleach                  = 60
	dragon_destroy_block    = 61
	mycelium_dust           = 62
	falling_border_dust     = 63
	campfire_smoke          = 64
	campfire_smoke_tall     = 65
	dragon_breath_fire      = 66
	dragon_breath_trail     = 67
	blue_flame              = 68
	soul                    = 69
	obsidian_tear           = 70
}

pub fn (e ParticleType) encode(mut w serializer.Writer) {
	w.write_varuint32(u32(e))
}

pub fn ParticleType.decode(mut r serializer.Reader) !ParticleType {
	return unsafe { ParticleType(r.read_varuint32()!) }
}
