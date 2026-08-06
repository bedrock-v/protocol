module packets

import protocol.serializer
import protocol.version.v776.enums

pub struct RequestAbilityUnset {}

pub struct RequestAbilityBool {
pub mut:
	variable_value bool
	default_value  f32
}

pub struct RequestAbilityFloat {
pub mut:
	variable_value f32
	default_value  bool
}

pub type RequestAbilityType = RequestAbilityBool | RequestAbilityFloat | RequestAbilityUnset

pub fn (t RequestAbilityType) encode(mut w serializer.Writer) {
	match t {
		RequestAbilityUnset {
			w.i8(0)
		}
		RequestAbilityBool {
			w.i8(1)
			w.bool(t.variable_value)
			w.le_f32(t.default_value)
		}
		RequestAbilityFloat {
			w.i8(2)
			w.le_f32(t.variable_value)
			w.bool(t.default_value)
		}
	}
}

pub fn RequestAbilityType.decode(mut r serializer.Reader) !RequestAbilityType {
	d := r.i8()!
	match d {
		0 {
			return RequestAbilityUnset{}
		}
		1 {
			return RequestAbilityBool{
				variable_value: r.bool()!
				default_value:  r.le_f32()!
			}
		}
		2 {
			return RequestAbilityFloat{
				variable_value: r.le_f32()!
				default_value:  r.bool()!
			}
		}
		else {
			return error('invalid RequestAbilityType ${d}')
		}
	}
}

pub struct RequestAbilityPacket {
pub mut:
	ability    enums.AbilitiesIndex
	value_type RequestAbilityType = RequestAbilityUnset{}
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
	p.ability.encode(mut w)
	p.value_type.encode(mut w)
}

pub fn (mut p RequestAbilityPacket) decode_payload(mut r serializer.Reader) ! {
	p.ability = enums.AbilitiesIndex.decode(mut r)!
	p.value_type = RequestAbilityType.decode(mut r)!
}
