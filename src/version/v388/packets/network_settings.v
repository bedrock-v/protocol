module packets

import serializer

pub struct NetworkSettingsPacket {
pub mut:
	compression_threshold u16
}

pub fn (p &NetworkSettingsPacket) pid() u16 {
	return 143
}

pub fn (p &NetworkSettingsPacket) name() string {
	return 'NetworkSettingsPacket'
}

pub fn (p &NetworkSettingsPacket) can_be_sent_before_login() bool {
	return true
}

pub fn (p &NetworkSettingsPacket) encode_payload(mut w serializer.Writer) {
	w.le_u16(p.compression_threshold)
}

pub fn (mut p NetworkSettingsPacket) decode_payload(mut r serializer.Reader) ! {
	p.compression_threshold = r.le_u16()!
}
