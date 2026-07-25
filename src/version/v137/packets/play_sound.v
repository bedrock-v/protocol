module packets

import serializer
import version.v137.types

pub struct PlaySoundPacket {
pub mut:
	sound_name string
	x          f32
	y          f32
	z          f32
	volume     f32
	pitch      f32
}

pub fn (p &PlaySoundPacket) pid() u16 {
	return 86
}

pub fn (p &PlaySoundPacket) name() string {
	return 'PlaySoundPacket'
}

pub fn (p &PlaySoundPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &PlaySoundPacket) encode_payload(mut w serializer.Writer) {
	w.write_string(p.sound_name)
	pos := types.BlockPosition{
		x: i32(p.x * 8)
		y: u32(i32(p.y * 8))
		z: i32(p.z * 8)
	}
	pos.encode(mut w)
	w.le_f32(p.volume)
	w.le_f32(p.pitch)
}

pub fn (mut p PlaySoundPacket) decode_payload(mut r serializer.Reader) ! {
	p.sound_name = r.read_string()!
	pos := types.BlockPosition.decode(mut r)!
	p.x = f32(pos.x) / 8
	p.y = f32(pos.y) / 8
	p.z = f32(pos.z) / 8
	p.volume = r.le_f32()!
	p.pitch = r.le_f32()!
}
