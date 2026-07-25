module packets

import serializer

pub struct LevelSoundEventPacket {
pub mut:
	event_name       string
	position         [3]f32
	data             i32
	actor_identifier string
	is_baby_mob      bool
	is_global        bool
	entity_unique_id u64
	fire_at_position ?[3]f32
}

pub fn (p &LevelSoundEventPacket) pid() u16 {
	return 123
}

pub fn (p &LevelSoundEventPacket) name() string {
	return 'LevelSoundEventPacket'
}

pub fn (p &LevelSoundEventPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &LevelSoundEventPacket) encode_payload(mut w serializer.Writer) {
	w.write_string(p.event_name)
	w.le_f32(p.position[0])
	w.le_f32(p.position[1])
	w.le_f32(p.position[2])
	w.write_varint32(p.data)
	w.write_string(p.actor_identifier)
	w.bool(p.is_baby_mob)
	w.bool(p.is_global)
	w.le_u64(p.entity_unique_id)
	if v := p.fire_at_position {
		w.bool(true)
		w.le_f32(v[0])
		w.le_f32(v[1])
		w.le_f32(v[2])
	} else {
		w.bool(false)
	}
}

pub fn (mut p LevelSoundEventPacket) decode_payload(mut r serializer.Reader) ! {
	p.event_name = r.read_string()!
	p.position = [r.le_f32()!, r.le_f32()!, r.le_f32()!]!
	p.data = r.read_varint32()!
	p.actor_identifier = r.read_string()!
	p.is_baby_mob = r.bool()!
	p.is_global = r.bool()!
	p.entity_unique_id = r.le_u64()!
	if r.bool()! {
		p.fire_at_position = [r.le_f32()!, r.le_f32()!, r.le_f32()!]!
	} else {
		p.fire_at_position = none
	}
}
