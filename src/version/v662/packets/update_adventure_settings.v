module packets

import protocol.serializer
import protocol.version.v662.types

pub struct UpdateAdventureSettingsPacket {
pub mut:
	adventure_settings types.AdventureSettings
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
	p.adventure_settings.encode(mut w)
}

pub fn (mut p UpdateAdventureSettingsPacket) decode_payload(mut r serializer.Reader) ! {
	p.adventure_settings = types.AdventureSettings.decode(mut r)!
}
