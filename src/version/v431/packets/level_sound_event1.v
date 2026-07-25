module packets

import serializer
import version.v291.types as types_291
import version.v431.enums

pub struct LevelSoundEvent1Packet {
pub mut:
	sound                    enums.SoundEvent
	position                 types_291.Vector3f
	extra_data               i32
	pitch                    i32
	baby_sound               bool
	relative_volume_disabled bool
}

pub fn (p &LevelSoundEvent1Packet) pid() u16 {
	return 24
}

pub fn (p &LevelSoundEvent1Packet) name() string {
	return 'LevelSoundEvent1Packet'
}

pub fn (p &LevelSoundEvent1Packet) can_be_sent_before_login() bool {
	return false
}

pub fn (p &LevelSoundEvent1Packet) encode_payload(mut w serializer.Writer) {
	w.u8(u8(p.sound))
	p.position.encode(mut w)
	w.write_varint32(p.extra_data)
	w.write_varint32(p.pitch)
	w.bool(p.baby_sound)
	w.bool(p.relative_volume_disabled)
}

pub fn (mut p LevelSoundEvent1Packet) decode_payload(mut r serializer.Reader) ! {
	p.sound = unsafe { enums.SoundEvent(r.u8()!) }
	p.position = types_291.Vector3f.decode(mut r)!
	p.extra_data = r.read_varint32()!
	p.pitch = r.read_varint32()!
	p.baby_sound = r.bool()!
	p.relative_volume_disabled = r.bool()!
}
