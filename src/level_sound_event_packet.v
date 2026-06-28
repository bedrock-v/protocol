module protocol

import serializer
import types

pub struct LevelSoundEventPacket {
pub mut:
	sound                   string
	position                types.Vector3
	extra_data              int
	entity_type             string
	is_baby_mob             bool
	disable_relative_volume bool
	actor_unique_id         i64
	fire_position           ?types.Vector3
}

pub fn (p &LevelSoundEventPacket) pid() u16 {
	return level_sound_event_packet
}

pub fn (p &LevelSoundEventPacket) name() string {
	return 'LevelSoundEventPacket'
}

pub fn (p &LevelSoundEventPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p LevelSoundEventPacket) decode_payload(mut r serializer.Reader) ! {
	p.sound = r.read_string()!
	p.position = r.read_vector3()!
	p.extra_data = int(r.read_varint32()!)
	p.entity_type = r.read_string()!
	p.is_baby_mob = r.bool()!
	p.disable_relative_volume = r.bool()!
	p.actor_unique_id = r.le_i64()!
	if r.bool()! {
		p.fire_position = r.read_vector3()!
	} else {
		p.fire_position = none
	}
}

pub fn (p &LevelSoundEventPacket) encode_payload(mut w serializer.Writer) {
	w.write_string(p.sound)
	w.write_vector3(p.position)
	w.write_varint32(i32(p.extra_data))
	w.write_string(p.entity_type)
	w.bool(p.is_baby_mob)
	w.bool(p.disable_relative_volume)
	w.le_i64(p.actor_unique_id)
	if pos := p.fire_position {
		w.bool(true)
		w.write_vector3(pos)
	} else {
		w.bool(false)
	}
}
