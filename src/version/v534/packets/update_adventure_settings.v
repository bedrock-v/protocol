module packets

import serializer

pub struct UpdateAdventureSettingsPacket {
pub mut:
	no_pvm          bool
	no_mvp          bool
	immutable_world bool
	show_name_tags  bool
	auto_jump       bool
}

pub fn (p &UpdateAdventureSettingsPacket) pid() u16 {
	return 188
}

pub fn (p &UpdateAdventureSettingsPacket) name() string {
	return 'UpdateAdventureSettingsPacket'
}

pub fn (p &UpdateAdventureSettingsPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &UpdateAdventureSettingsPacket) encode_payload(mut w serializer.Writer) {
	w.bool(p.no_pvm)
	w.bool(p.no_mvp)
	w.bool(p.immutable_world)
	w.bool(p.show_name_tags)
	w.bool(p.auto_jump)
}

pub fn (mut p UpdateAdventureSettingsPacket) decode_payload(mut r serializer.Reader) ! {
	p.no_pvm = r.bool()!
	p.no_mvp = r.bool()!
	p.immutable_world = r.bool()!
	p.show_name_tags = r.bool()!
	p.auto_jump = r.bool()!
}
