module packets

import serializer

pub struct StopSoundPacket {
pub mut:
	string1  string
	stop_all bool
}

pub fn (p &StopSoundPacket) pid() u16 {
	return 0x57
}

pub fn (p &StopSoundPacket) name() string {
	return 'StopSoundPacket'
}

pub fn (p &StopSoundPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &StopSoundPacket) encode_payload(mut w serializer.Writer) {
	w.write_string(p.string1)
	w.u8(if p.stop_all { u8(1) } else { u8(0) })
}

pub fn (mut p StopSoundPacket) decode_payload(mut r serializer.Reader) ! {
	p.string1 = r.read_string()!
	p.stop_all = r.u8()! > 0
}
