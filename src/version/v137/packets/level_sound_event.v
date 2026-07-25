module packets

import serializer
import version.v137.types

pub struct LevelSoundEventPacket {
pub mut:
	sound                   u8
	position                types.Vector3f
	extra_data              i32
	pitch                   i32
	unknown_bool            bool
	disable_relative_volume bool
}

pub fn (p &LevelSoundEventPacket) pid() u16 {
	return 24
}

pub fn (p &LevelSoundEventPacket) name() string {
	return 'LevelSoundEventPacket'
}

pub fn (p &LevelSoundEventPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &LevelSoundEventPacket) encode_payload(mut w serializer.Writer) {
	w.u8(p.sound)
	p.position.encode(mut w)
	w.write_varint32(p.extra_data)
	w.write_varint32(p.pitch)
	w.bool(p.unknown_bool)
	w.bool(p.disable_relative_volume)
}

pub fn (mut p LevelSoundEventPacket) decode_payload(mut r serializer.Reader) ! {
	p.sound = r.u8()!
	p.position = types.Vector3f.decode(mut r)!
	p.extra_data = r.read_varint32()!
	p.pitch = r.read_varint32()!
	p.unknown_bool = r.bool()!
	p.disable_relative_volume = r.bool()!
}
