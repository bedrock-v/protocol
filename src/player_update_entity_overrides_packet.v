module protocol

import serializer

pub const override_update_type_clear = u8(0)
pub const override_update_type_set_int = u8(1)
pub const override_update_type_set_float = u8(2)
pub const override_update_type_remove = u8(3)

pub struct PlayerUpdateEntityOverridesPacket {
pub mut:
	actor_runtime_id    u64
	property_index      u32
	update_type         u8
	int_override_value  int
	float_override_value f32
}

pub fn (p &PlayerUpdateEntityOverridesPacket) pid() u16 {
	return player_update_entity_overrides_packet
}

pub fn (p &PlayerUpdateEntityOverridesPacket) name() string {
	return 'PlayerUpdateEntityOverridesPacket'
}

pub fn (p &PlayerUpdateEntityOverridesPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p PlayerUpdateEntityOverridesPacket) decode_payload(mut r serializer.Reader) ! {
	p.actor_runtime_id = r.read_actor_runtime_id()!
	p.property_index = r.read_varuint32()!
	p.update_type = r.u8()!
	if p.update_type == override_update_type_set_int {
		p.int_override_value = int(r.le_i32()!)
	} else if p.update_type == override_update_type_set_float {
		p.float_override_value = r.le_f32()!
	}
}

pub fn (p &PlayerUpdateEntityOverridesPacket) encode_payload(mut w serializer.Writer) {
	w.write_actor_runtime_id(p.actor_runtime_id)
	w.write_varuint32(p.property_index)
	w.u8(p.update_type)
	if p.update_type == override_update_type_set_int {
		w.le_i32(i32(p.int_override_value))
	} else if p.update_type == override_update_type_set_float {
		w.le_f32(p.float_override_value)
	}
}
