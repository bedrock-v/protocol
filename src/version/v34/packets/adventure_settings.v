module packets

import serializer

pub struct AdventureSettingsPacket {
pub mut:
	flags i32
}

pub fn (p &AdventureSettingsPacket) pid() u16 {
	return 0xbc
}

pub fn (p &AdventureSettingsPacket) name() string {
	return 'AdventureSettingsPacket'
}

pub fn (p &AdventureSettingsPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &AdventureSettingsPacket) encode_payload(mut w serializer.Writer) {
	w.be_i32(p.flags)
}

pub fn (mut p AdventureSettingsPacket) decode_payload(mut r serializer.Reader) ! {
	p.flags = r.be_i32()!
}
