module enums

import protocol.serializer

pub enum ParticleType as u32 {
	undefined               = 0
	bubble                  = 1
	crit                    = 2
	block_force_field       = 3
	smoke                   = 4
	explode                 = 5
	evaporation             = 6
	flame                   = 7
	lava                    = 8
	large_smoke             = 9
	red_dust                = 10
	rising_border_dust      = 11
	icon_crack              = 12
	snowball_poof           = 13
	large_explode           = 14
	huge_explosion          = 15
	mob_flame               = 16
	heart                   = 17
	terrain                 = 18
	town_aura               = 19
	portal                  = 20
	water_splash            = 21
	water_wake              = 22
	drip_water              = 23
	drip_lava               = 24
	falling_dust            = 25
	mob_spell               = 26
	mob_spell_ambient       = 27
	mob_spell_instantaneous = 28
	ink                     = 29
	slime                   = 30
	rain_splash             = 31
	villager_angry          = 32
	villager_happy          = 33
	enchanting_table        = 34
	tracker_emitter         = 35
	note                    = 36
	witch_spell             = 37
	carrot_boost            = 38
	mob_appearance          = 39
	end_rod                 = 40
	dragon_breath           = 41
	spit                    = 42
	totem                   = 43
	food                    = 44
}

pub fn (e ParticleType) encode(mut w serializer.Writer) {
	w.write_varuint32(u32(e))
}

pub fn ParticleType.decode(mut r serializer.Reader) !ParticleType {
	return unsafe { ParticleType(r.read_varuint32()!) }
}
