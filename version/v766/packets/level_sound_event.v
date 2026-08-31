module packets

import protocol.serializer
import protocol.version.v766.enums

pub struct LevelSoundEventPacket {
pub mut:
	event_id         enums.LevelSoundEventType
	position         [3]f32
	data             i32
	actor_identifier string
	is_baby_mob      bool
	is_global        bool
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
	p.event_id.encode(mut w)
	w.le_f32(p.position[0])
	w.le_f32(p.position[1])
	w.le_f32(p.position[2])
	w.write_varint32(p.data)
	w.write_string(p.actor_identifier)
	w.bool(p.is_baby_mob)
	w.bool(p.is_global)
}

pub fn (mut p LevelSoundEventPacket) decode_payload(mut r serializer.Reader) ! {
	p.event_id = enums.LevelSoundEventType.decode(mut r)!
	p.position = [r.le_f32()!, r.le_f32()!, r.le_f32()!]!
	p.data = r.read_varint32()!
	p.actor_identifier = r.read_string()!
	p.is_baby_mob = r.bool()!
	p.is_global = r.bool()!
}
