module enums

import serializer

pub enum AbilitiesIndex as i32 {
	invalid            = -1
	build              = 0
	mine               = 1
	doors_and_switches = 2
	open_containers    = 3
	attack_players     = 4
	attack_mobs        = 5
	operator_commands  = 6
	teleport           = 7
	invulnerable       = 8
	flying             = 9
	may_fly            = 10
	instabuild         = 11
	lightning          = 12
	fly_speed          = 13
	walk_speed         = 14
	muted              = 15
	world_builder      = 16
	no_clip            = 17
	privileged_builder = 18
	vertical_fly_speed = 19
}

pub fn (e AbilitiesIndex) encode(mut w serializer.Writer) {
	w.write_varint32(i32(e))
}

pub fn AbilitiesIndex.decode(mut r serializer.Reader) !AbilitiesIndex {
	return unsafe { AbilitiesIndex(r.read_varint32()!) }
}
