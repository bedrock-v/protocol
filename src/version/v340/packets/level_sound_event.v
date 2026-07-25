module packets

import serializer
import version.v291.types
import version.v340.enums

pub struct LevelSoundEventPacket {
pub mut:
	sound                    enums.SoundEvent
	position                 types.Vector3f
	extra_data               i32
	identifier               string
	baby_sound               bool
	relative_volume_disabled bool
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
	p.sound.encode(mut w)
	p.position.encode(mut w)
	w.write_varint32(p.extra_data)
	w.write_string(p.identifier)
	w.bool(p.baby_sound)
	w.bool(p.relative_volume_disabled)
}

pub fn (mut p LevelSoundEventPacket) decode_payload(mut r serializer.Reader) ! {
	p.sound = enums.SoundEvent.decode(mut r)!
	p.position = types.Vector3f.decode(mut r)!
	p.extra_data = r.read_varint32()!
	p.identifier = r.read_string()!
	p.baby_sound = r.bool()!
	p.relative_volume_disabled = r.bool()!
}
