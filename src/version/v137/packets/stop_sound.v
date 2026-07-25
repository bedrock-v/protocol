module packets

import serializer

pub struct StopSoundPacket {
pub mut:
	sound_name string
	stop_all   bool
}

pub fn (p &StopSoundPacket) pid() u16 {
	return 87
}

pub fn (p &StopSoundPacket) name() string {
	return 'StopSoundPacket'
}

pub fn (p &StopSoundPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &StopSoundPacket) encode_payload(mut w serializer.Writer) {
	w.write_string(p.sound_name)
	w.bool(p.stop_all)
}

pub fn (mut p StopSoundPacket) decode_payload(mut r serializer.Reader) ! {
	p.sound_name = r.read_string()!
	p.stop_all = r.bool()!
}
