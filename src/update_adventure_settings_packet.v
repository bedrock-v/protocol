module src

import src.serializer

pub struct UpdateAdventureSettingsPacket {
pub mut:
	no_attacking_mobs    bool
	no_attacking_players bool
	world_immutable      bool
	show_name_tags       bool
	auto_jump            bool
}

pub fn (p &UpdateAdventureSettingsPacket) pid() u16 {
	return update_adventure_settings_packet
}

pub fn (p &UpdateAdventureSettingsPacket) name() string {
	return 'UpdateAdventureSettingsPacket'
}

pub fn (p &UpdateAdventureSettingsPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p UpdateAdventureSettingsPacket) decode_payload(mut r serializer.Reader) ! {
	p.no_attacking_mobs = r.bool()!
	p.no_attacking_players = r.bool()!
	p.world_immutable = r.bool()!
	p.show_name_tags = r.bool()!
	p.auto_jump = r.bool()!
}

pub fn (p &UpdateAdventureSettingsPacket) encode_payload(mut w serializer.Writer) {
	w.bool(p.no_attacking_mobs)
	w.bool(p.no_attacking_players)
	w.bool(p.world_immutable)
	w.bool(p.show_name_tags)
	w.bool(p.auto_jump)
}
