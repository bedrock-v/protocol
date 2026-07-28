module packets

import protocol.serializer

pub struct EducationSettingsPacket {
pub mut:
	code_builder_uri        string
	code_builder_title      string
	can_resize_code_builder bool
	has_override_uri        bool
	override_uri            string
	quiz_attached           bool
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
	w.write_string(p.code_builder_title)
	w.bool(p.can_resize_code_builder)
	w.bool(p.has_override_uri)
	if p.has_override_uri {
		w.write_string(p.override_uri)
	}
	w.bool(p.quiz_attached)
}

pub fn (mut p EducationSettingsPacket) decode_payload(mut r serializer.Reader) ! {
	p.code_builder_uri = r.read_string()!
	p.code_builder_title = r.read_string()!
	p.can_resize_code_builder = r.bool()!
	p.has_override_uri = r.bool()!
	if p.has_override_uri {
		p.override_uri = r.read_string()!
	}
	p.quiz_attached = r.bool()!
}
