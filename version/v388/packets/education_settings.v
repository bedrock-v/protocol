module packets

import protocol.serializer

pub struct EducationSettingsPacket {
pub mut:
	code_builder_uri string
	quiz_attached    bool
}

pub fn (p &EducationSettingsPacket) pid() u16 {
	return 137
}

pub fn (p &EducationSettingsPacket) name() string {
	return 'EducationSettingsPacket'
}

pub fn (p &EducationSettingsPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &EducationSettingsPacket) encode_payload(mut w serializer.Writer) {
	w.write_string(p.code_builder_uri)
	w.bool(p.quiz_attached)
}

pub fn (mut p EducationSettingsPacket) decode_payload(mut r serializer.Reader) ! {
	p.code_builder_uri = r.read_string()!
	p.quiz_attached = r.bool()!
}
