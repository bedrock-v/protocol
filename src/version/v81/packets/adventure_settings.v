module packets

import serializer

pub struct AdventureSettingsPacket {
pub mut:
	flags             i32
	user_permission   i32
	global_permission i32
}

pub fn (p &AdventureSettingsPacket) pid() u16 {
	return 0x31
}

pub fn (p &AdventureSettingsPacket) name() string {
	return 'AdventureSettingsPacket'
}

pub fn (p &AdventureSettingsPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &AdventureSettingsPacket) encode_payload(mut w serializer.Writer) {
	w.be_i32(p.flags)
	w.be_i32(p.user_permission)
	w.be_i32(p.global_permission)
}

pub fn (mut p AdventureSettingsPacket) decode_payload(mut r serializer.Reader) ! {
	p.flags = r.be_i32()!
	p.user_permission = r.be_i32()!
	p.global_permission = r.be_i32()!
}
