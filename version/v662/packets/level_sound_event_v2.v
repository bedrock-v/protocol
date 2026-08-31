module packets

import protocol.serializer
import protocol.version.v662.enums

pub struct LevelSoundEventV2Packet {
pub mut:
	event_id         enums.LevelSoundEventType
	position         [3]f32
	data             i32
	actor_identifier string
	baby_mob         bool
	global           bool
}

pub fn (p &LevelSoundEventV2Packet) pid() u16 {
	return 120
}

pub fn (p &LevelSoundEventV2Packet) name() string {
	return 'LevelSoundEventV2Packet'
}

pub fn (p &LevelSoundEventV2Packet) can_be_sent_before_login() bool {
	return false
}

pub fn (p &LevelSoundEventV2Packet) encode_payload(mut w serializer.Writer) {
	w.u8(u8(u32(p.event_id)))
	w.le_f32(p.position[0])
	w.le_f32(p.position[1])
	w.le_f32(p.position[2])
	w.write_varint32(p.data)
	w.write_string(p.actor_identifier)
	w.bool(p.baby_mob)
	w.bool(p.global)
}

pub fn (mut p LevelSoundEventV2Packet) decode_payload(mut r serializer.Reader) ! {
	p.event_id = unsafe { enums.LevelSoundEventType(u32(r.u8()!)) }
	p.position = [r.le_f32()!, r.le_f32()!, r.le_f32()!]!
	p.data = r.read_varint32()!
	p.actor_identifier = r.read_string()!
	p.baby_mob = r.bool()!
	p.global = r.bool()!
}
