module src

import src.serializer

pub struct StopSoundPacket {
pub mut:
	sound_name        string
	stop_all          bool
	stop_legacy_music bool
}

pub fn (p &StopSoundPacket) pid() u16 {
	return stop_sound_packet
}

pub fn (p &StopSoundPacket) name() string {
	return 'StopSoundPacket'
}

pub fn (p &StopSoundPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p StopSoundPacket) decode_payload(mut r serializer.Reader) ! {
	p.sound_name = r.read_string()!
	p.stop_all = r.bool()!
	p.stop_legacy_music = r.bool()!
}

pub fn (p &StopSoundPacket) encode_payload(mut w serializer.Writer) {
	w.write_string(p.sound_name)
	w.bool(p.stop_all)
	w.bool(p.stop_legacy_music)
}
