module packets

import serializer
import version.v291.types

pub struct AdventureSettingsPacket {
pub mut:
	settings types.AdventureSettingsData
}

pub fn (p &AdventureSettingsPacket) pid() u16 {
	return 55
}

pub fn (p &AdventureSettingsPacket) name() string {
	return 'AdventureSettingsPacket'
}

pub fn (p &AdventureSettingsPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &AdventureSettingsPacket) encode_payload(mut w serializer.Writer) {
	p.settings.encode(mut w)
}

pub fn (mut p AdventureSettingsPacket) decode_payload(mut r serializer.Reader) ! {
	p.settings = types.AdventureSettingsData.decode(mut r)!
}
