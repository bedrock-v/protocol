module packets

import serializer

pub struct ClientBoundUpdateSoundDataPacket {
pub mut:
	server_sound_handle i64
	sound_type          string
}

pub fn (p &ClientBoundUpdateSoundDataPacket) pid() u16 {
	return 348
}

pub fn (p &ClientBoundUpdateSoundDataPacket) name() string {
	return 'ClientBoundUpdateSoundDataPacket'
}

pub fn (p &ClientBoundUpdateSoundDataPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &ClientBoundUpdateSoundDataPacket) encode_payload(mut w serializer.Writer) {
	w.le_i64(p.server_sound_handle)
	w.write_string(p.sound_type)
}

pub fn (mut p ClientBoundUpdateSoundDataPacket) decode_payload(mut r serializer.Reader) ! {
	p.server_sound_handle = r.le_i64()!
	p.sound_type = r.read_string()!
}
