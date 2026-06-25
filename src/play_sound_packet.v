module src

import src.serializer
import src.types

pub struct PlaySoundPacket {
pub mut:
	sound_name          string
	position            types.BlockPosition
	volume              f32
	pitch               f32
	server_sound_handle ?u64
}

pub fn (p &PlaySoundPacket) pid() u16 {
	return play_sound_packet
}

pub fn (p &PlaySoundPacket) name() string {
	return 'PlaySoundPacket'
}

pub fn (p &PlaySoundPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p PlaySoundPacket) decode_payload(mut r serializer.Reader) ! {
	p.sound_name = r.read_string()!
	p.position = r.read_block_position()!
	p.volume = r.le_f32()!
	p.pitch = r.le_f32()!
	if r.bool()! {
		p.server_sound_handle = r.le_u64()!
	} else {
		p.server_sound_handle = none
	}
}

pub fn (p &PlaySoundPacket) encode_payload(mut w serializer.Writer) {
	w.write_string(p.sound_name)
	w.write_block_position(p.position)
	w.le_f32(p.volume)
	w.le_f32(p.pitch)
	if handle := p.server_sound_handle {
		w.bool(true)
		w.le_u64(handle)
	} else {
		w.bool(false)
	}
}
