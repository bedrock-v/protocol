module protocol

import serializer

pub const ability_value_type_bool = 1
pub const ability_value_type_float = 2

pub struct RequestAbilityPacket {
pub mut:
	ability_id  int
	value_type  int
	bool_value  bool
	float_value f32
}

pub fn (p &RequestAbilityPacket) pid() u16 {
	return request_ability_packet
}

pub fn (p &RequestAbilityPacket) name() string {
	return 'RequestAbilityPacket'
}

pub fn (p &RequestAbilityPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p RequestAbilityPacket) decode_payload(mut r serializer.Reader) ! {
	p.ability_id = int(r.read_varint32()!)
	p.value_type = int(r.u8()!)
	p.bool_value = r.bool()!
	p.float_value = r.le_f32()!
}

pub fn (p &RequestAbilityPacket) encode_payload(mut w serializer.Writer) {
	w.write_varint32(i32(p.ability_id))
	w.u8(u8(p.value_type))
	w.bool(p.bool_value)
	w.le_f32(p.float_value)
}
