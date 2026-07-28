module enums

import protocol.serializer

pub enum ActorDamageCause as i32 {
	@none            = -1
	override         = 0
	contact          = 1
	entity_attack    = 2
	projectile       = 3
	suffocation      = 4
	fall             = 5
	fire             = 6
	fire_tick        = 7
	lava             = 8
	drowning         = 9
	block_explosion  = 10
	entity_explosion = 11
	void             = 12
	self_destruct    = 13
	magic            = 14
	wither           = 15
	starve           = 16
	anvil            = 17
	thorns           = 18
	falling_block    = 19
	piston           = 20
	fly_into_wall    = 21
	magma            = 22
	fireworks        = 23
	lightning        = 24
	charging         = 25
	temperature      = 26
	freezing         = 27
	stalactite       = 28
	stalagmite       = 29
	ram_attack       = 30
	sonic_boom       = 31
	campfire         = 32
	soul_campfire    = 33
	all              = 34
}

pub fn (e ActorDamageCause) encode(mut w serializer.Writer) {
	w.write_varint32(i32(e))
}

pub fn ActorDamageCause.decode(mut r serializer.Reader) !ActorDamageCause {
	return unsafe { ActorDamageCause(r.read_varint32()!) }
}
