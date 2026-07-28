module enums

import protocol.serializer

pub enum EnchantType as i8 {
	armor_all             = 0
	armor_fire            = 1
	armor_fall            = 2
	armor_explosive       = 3
	armor_projectile      = 4
	armor_thorns          = 5
	water_breath          = 6
	water_speed           = 7
	water_affinity        = 8
	weapon_damage         = 9
	weapon_undead         = 10
	weapon_arthropod      = 11
	weapon_knockback      = 12
	weapon_fire           = 13
	weapon_loot           = 14
	mining_efficiency     = 15
	mining_silk_touch     = 16
	mining_durability     = 17
	mining_loot           = 18
	bow_damage            = 19
	bow_knockback         = 20
	bow_fire              = 21
	bow_infinity          = 22
	fishing_loot          = 23
	fishing_lure          = 24
	frost_walker          = 25
	mending               = 26
	curse_binding         = 27
	curse_vanishing       = 28
	trident_impaling      = 29
	trident_riptide       = 30
	trident_loyalty       = 31
	trident_channeling    = 32
	crossbow_multishot    = 33
	crossbow_piercing     = 34
	crossbow_quick_charge = 35
	soul_speed            = 36
	swift_sneak           = 37
	num_enchantments      = 38
	invalid_enchantment   = 39
}

pub fn (e EnchantType) encode(mut w serializer.Writer) {
	w.i8(i8(e))
}

pub fn EnchantType.decode(mut r serializer.Reader) !EnchantType {
	return unsafe { EnchantType(r.i8()!) }
}
