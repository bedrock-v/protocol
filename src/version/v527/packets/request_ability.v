module packets

import serializer

pub enum RequestAbility as i32 {
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

pub enum RequestAbilityValueType as u8 {
	@none   = 0
	boolean = 1
	float   = 2
}

pub struct RequestAbilityPacket {
pub mut:
	ability     RequestAbility
	value_type  RequestAbilityValueType
	bool_value  bool
	float_value f32
}

pub fn (p &RequestAbilityPacket) pid() u16 {
	return 184
}

pub fn (p &RequestAbilityPacket) name() string {
	return 'RequestAbilityPacket'
}

pub fn (p &RequestAbilityPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &RequestAbilityPacket) encode_payload(mut w serializer.Writer) {
	w.write_varint32(i32(p.ability))
	w.u8(u8(p.value_type))
	w.bool(p.bool_value)
	w.le_f32(p.float_value)
}

pub fn (mut p RequestAbilityPacket) decode_payload(mut r serializer.Reader) ! {
	p.ability = unsafe { RequestAbility(r.read_varint32()!) }
	p.value_type = unsafe { RequestAbilityValueType(r.u8()!) }
	p.bool_value = r.bool()!
	p.float_value = r.le_f32()!
}
