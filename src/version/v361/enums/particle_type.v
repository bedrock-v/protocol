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
	falling_dust            = 28
	mob_spell               = 29
	mob_spell_ambient       = 30
	mob_spell_instantaneous = 31
	ink                     = 32
	slime                   = 33
	rain_splash             = 34
	villager_angry          = 35
	villager_happy          = 36
	enchanting_table        = 37
	tracker_emitter         = 38
	note                    = 39
	witch_spell             = 40
	carrot_boost            = 41
	mob_appearance          = 42
	end_rod                 = 43
	dragon_breath           = 44
	spit                    = 45
	totem                   = 46
	food                    = 47
	fireworks_starter       = 48
	fireworks               = 49
	fireworks_overlay       = 50
	balloon_gas             = 51
	colored_flame           = 52
	sparkler                = 53
	conduit                 = 54
	bubble_column_up        = 55
	bubble_column_down      = 56
	sneeze                  = 57
}

pub fn (e ParticleType) encode(mut w serializer.Writer) {
	w.write_varuint32(u32(e))
}

pub fn ParticleType.decode(mut r serializer.Reader) !ParticleType {
	return unsafe { ParticleType(r.read_varuint32()!) }
}
