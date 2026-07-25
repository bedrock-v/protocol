module packets

import serializer

pub struct LevelSoundEventPacket {
pub mut:
	sound         u8
	x             f32
	y             f32
	z             f32
	extra_data    i32
	pitch         i32
	unknown_bool  bool
	unknown_bool2 bool
}

pub fn (p &LevelSoundEventPacket) pid() u16 {
	return 0x1a
}

pub fn (p &LevelSoundEventPacket) name() string {
	return 'LevelSoundEventPacket'
}

pub fn (p &LevelSoundEventPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &LevelSoundEventPacket) encode_payload(mut w serializer.Writer) {
	w.u8(p.sound)
	w.le_f32(p.x)
	w.le_f32(p.y)
	w.le_f32(p.z)
	w.write_varint32(p.extra_data)
	w.write_varint32(p.pitch)
	w.u8(if p.unknown_bool { u8(1) } else { u8(0) })
	w.u8(if p.unknown_bool2 { u8(1) } else { u8(0) })
}

pub fn (mut p LevelSoundEventPacket) decode_payload(mut r serializer.Reader) ! {
	p.sound = r.u8()!
	p.x = r.le_f32()!
	p.y = r.le_f32()!
	p.z = r.le_f32()!
	p.extra_data = r.read_varint32()!
	p.pitch = r.read_varint32()!
	p.unknown_bool = r.u8()! > 0
	p.unknown_bool2 = r.u8()! > 0
}
