module packets

import protocol.serializer
import protocol.version.v137.types

pub struct PlaySoundPacket {
pub mut:
	sound_name string
	position   types.BlockPosition
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
	p.position.encode(mut w)
	w.le_f32(p.volume)
	w.le_f32(p.pitch)
}

pub fn (mut p PlaySoundPacket) decode_payload(mut r serializer.Reader) ! {
	p.sound_name = r.read_string()!
	p.position = types.BlockPosition.decode(mut r)!
	p.volume = r.le_f32()!
	p.pitch = r.le_f32()!
}
