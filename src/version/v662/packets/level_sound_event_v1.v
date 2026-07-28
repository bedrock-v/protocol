module packets

import protocol.serializer
import protocol.version.v662.enums

pub struct LevelSoundEventV1Packet {
pub mut:
	event_id   enums.LevelSoundEventType
	position   [3]f32
	data       i32
	actor_type enums.ActorType
	baby_mob   bool
	global     bool
}

pub fn (p &LevelSoundEventV1Packet) pid() u16 {
	return 24
}

pub fn (p &LevelSoundEventV1Packet) name() string {
	return 'LevelSoundEventV1Packet'
}

pub fn (p &LevelSoundEventV1Packet) can_be_sent_before_login() bool {
	return false
}

pub fn (p &LevelSoundEventV1Packet) encode_payload(mut w serializer.Writer) {
	w.u8(u8(u32(p.event_id)))
	w.le_f32(p.position[0])
	w.le_f32(p.position[1])
	w.le_f32(p.position[2])
	w.write_varint32(p.data)
	p.actor_type.encode(mut w)
	w.bool(p.baby_mob)
	w.bool(p.global)
}

pub fn (mut p LevelSoundEventV1Packet) decode_payload(mut r serializer.Reader) ! {
	p.event_id = unsafe { enums.LevelSoundEventType(u32(r.u8()!)) }
	p.position = [r.le_f32()!, r.le_f32()!, r.le_f32()!]!
	p.data = r.read_varint32()!
	p.actor_type = enums.ActorType.decode(mut r)!
	p.baby_mob = r.bool()!
	p.global = r.bool()!
}
