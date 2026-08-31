module packets

import protocol.serializer

pub struct PlaySoundPacket {
pub mut:
	sound_name string
	x          i32
	y          u32
	z          i32
	volume     f32
	pitch      f32
}

pub fn (p &PlaySoundPacket) pid() u16 {
	return 0x57
}

pub fn (p &PlaySoundPacket) name() string {
	return 'PlaySoundPacket'
}

pub fn (p &PlaySoundPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &PlaySoundPacket) encode_payload(mut w serializer.Writer) {
	w.write_string(p.sound_name)
	w.write_varint32(p.x)
	w.write_varuint32(p.y)
	w.write_varint32(p.z)
	w.le_f32(p.volume)
	w.le_f32(p.pitch)
}

pub fn (mut p PlaySoundPacket) decode_payload(mut r serializer.Reader) ! {
	p.sound_name = r.read_string()!
	p.x = r.read_varint32()!
	p.y = r.read_varuint32()!
	p.z = r.read_varint32()!
	p.volume = r.le_f32()!
	p.pitch = r.le_f32()!
}
