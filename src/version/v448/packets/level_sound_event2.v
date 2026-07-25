module packets

import serializer
import version.v448.enums
import version.v291.types

pub struct LevelSoundEvent2Packet {
pub mut:
	sound                    enums.SoundEvent
	position                 types.Vector3f
	extra_data               i32
	identifier               string
	baby_sound               bool
	relative_volume_disabled bool
}

pub fn (p &LevelSoundEvent2Packet) pid() u16 {
	return 120
}

pub fn (p &LevelSoundEvent2Packet) name() string {
	return 'LevelSoundEvent2Packet'
}

pub fn (p &LevelSoundEvent2Packet) can_be_sent_before_login() bool {
	return false
}

pub fn (p &LevelSoundEvent2Packet) encode_payload(mut w serializer.Writer) {
	w.u8(u8(p.sound))
	p.position.encode(mut w)
	w.write_varint32(p.extra_data)
	w.write_string(p.identifier)
	w.bool(p.baby_sound)
	w.bool(p.relative_volume_disabled)
}

pub fn (mut p LevelSoundEvent2Packet) decode_payload(mut r serializer.Reader) ! {
	p.sound = unsafe { enums.SoundEvent(r.u8()!) }
	p.position = types.Vector3f.decode(mut r)!
	p.extra_data = r.read_varint32()!
	p.identifier = r.read_string()!
	p.baby_sound = r.bool()!
	p.relative_volume_disabled = r.bool()!
}
