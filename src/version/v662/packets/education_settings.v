module packets

import serializer
import version.v662.types

pub struct EducationSettingsPacket {
pub mut:
	education_level_settings types.EducationLevelSettings
}

pub fn (p &EducationSettingsPacket) pid() u16 { return 137 }

pub fn (p &EducationSettingsPacket) name() string { return 'EducationSettingsPacket' }

pub fn (p &EducationSettingsPacket) can_be_sent_before_login() bool { return false }

pub fn (p &EducationSettingsPacket) encode_payload(mut w serializer.Writer) {
	p.education_level_settings.encode(mut w)
}

pub fn (mut p EducationSettingsPacket) decode_payload(mut r serializer.Reader) ! {
	p.education_level_settings = types.EducationLevelSettings.decode(mut r)!
}
