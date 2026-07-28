module enums

import protocol.serializer

pub enum ActorFlags as i32 {
	unknown                       = -1
	on_fire                       = 0
	sneaking                      = 1
	riding                        = 2
	sprinting                     = 3
	using_item                    = 4
	invisible                     = 5
	tempted                       = 6
	in_love                       = 7
	saddled                       = 8
	powered                       = 9
	ignited                       = 10
	baby                          = 11
	converting                    = 12
	critical                      = 13
	can_show_name                 = 14
	always_show_name              = 15
	no_ai                         = 16
	silent                        = 17
	wall_climbing                 = 18
	can_climb                     = 19
	can_swim                      = 20
	can_fly                       = 21
	can_walk                      = 22
	resting                       = 23
	sitting                       = 24
	angry                         = 25
	interested                    = 26
	charged                       = 27
	tamed                         = 28
	orphaned                      = 29
	leashed                       = 30
	sheared                       = 31
	gliding                       = 32
	elder                         = 33
	moving                        = 34
	breathing                     = 35
	chested                       = 36
	stackable                     = 37
	show_bottom                   = 38
	standing                      = 39
	shaking                       = 40
	idling                        = 41
	casting                       = 42
	charging                      = 43
	wasd_controlled               = 44
	can_power_jump                = 45
	can_dash                      = 46
	lingering                     = 47
	has_collision                 = 48
	has_gravity                   = 49
	fire_immune                   = 50
	dancing                       = 51
	enchanted                     = 52
	return_trident                = 53
	container_is_private          = 54
	is_transforming               = 55
	damage_nearby_mobs            = 56
	swimming                      = 57
	bribed                        = 58
	is_pregnant                   = 59
	laying_egg                    = 60
	passenger_can_pick            = 61
	transition_sitting            = 62
	eating                        = 63
	laying_down                   = 64
	sneezing                      = 65
	trusting                      = 66
	rolling                       = 67
	scared                        = 68
	in_scaffolding                = 69
	over_scaffolding              = 70
	descend_through_block         = 71
	blocking                      = 72
	transition_blocking           = 73
	blocked_using_shield          = 74
	blocked_using_damaged_shield  = 75
	sleeping                      = 76
	wants_to_wake                 = 77
	trade_interest                = 78
	door_breaker                  = 79
	breaking_obstruction          = 80
	door_opener                   = 81
	is_illager_captain            = 82
	stunned                       = 83
	roaring                       = 84
	delayed_attack                = 85
	is_avoiding_mobs              = 86
	is_avoiding_block             = 87
	facing_target_to_range_attack = 88
	hidden_when_invisible         = 89
	is_in_ui                      = 90
	stalking                      = 91
	emoting                       = 92
	celebrating                   = 93
	admiring                      = 94
	celebrating_special           = 95
	out_of_control                = 96
	ram_attack                    = 97
	playing_dead                  = 98
	in_ascendable_block           = 99
	over_descendable_block        = 100
	croaking                      = 101
	eat_mob                       = 102
	jump_goal_jump                = 103
	emerging                      = 104
	sniffing                      = 105
	digging                       = 106
	sonic_boom                    = 107
	has_dash_cooldown             = 108
	push_towards_closest_space    = 109
	scenting                      = 110
	rising                        = 111
	feeling_happy                 = 112
	searching                     = 113
	crawling                      = 114
	timer_flag1                   = 115
	timer_flag2                   = 116
	timer_flag3                   = 117
	count                         = 118
}

pub fn (e ActorFlags) encode(mut w serializer.Writer) {
	w.write_varint32(i32(e))
}

pub fn ActorFlags.decode(mut r serializer.Reader) !ActorFlags {
	return unsafe { ActorFlags(r.read_varint32()!) }
}
