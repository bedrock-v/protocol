module packets

import protocol.serializer
import protocol.version.v944.types as types_944

pub struct PlaySoundPacket {
pub mut:
	name                string
	position            types_944.NetworkBlockPosition
	volume              f32
	pitch               f32
	loop_count          i32
	server_sound_handle ?i64
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
	w.write_string(p.name)
	p.position.encode(mut w)
	w.le_f32(p.volume)
	w.le_f32(p.pitch)
	w.write_varint32(p.loop_count)
	if v := p.server_sound_handle {
		w.bool(true)
		w.le_i64(v)
	} else {
		w.bool(false)
	}
}

pub fn (mut p PlaySoundPacket) decode_payload(mut r serializer.Reader) ! {
	p.name = r.read_string()!
	p.position = types_944.NetworkBlockPosition.decode(mut r)!
	p.volume = r.le_f32()!
	p.pitch = r.le_f32()!
	p.loop_count = r.read_varint32()!
	if r.bool()! {
		p.server_sound_handle = r.le_i64()!
	}
}
