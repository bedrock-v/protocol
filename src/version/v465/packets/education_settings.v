module packets

import protocol.serializer

pub struct EducationSettingsPacket {
pub mut:
	code_builder_uri           string
	code_builder_title         string
	can_resize_code_builder    bool
	disable_legacy_title       bool
	post_process_filter        string
	screenshot_border_path     string
	has_entity_capabilities    bool
	entity_capabilities        bool
	has_override_uri           bool
	override_uri               string
	quiz_attached              bool
	has_external_link_settings bool
	external_link_settings     bool
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
	w.bool(p.disable_legacy_title)
	w.write_string(p.post_process_filter)
	w.write_string(p.screenshot_border_path)
	w.bool(p.has_entity_capabilities)
	if p.has_entity_capabilities {
		w.bool(p.entity_capabilities)
	}
	w.bool(p.has_override_uri)
	if p.has_override_uri {
		w.write_string(p.override_uri)
	}
	w.bool(p.quiz_attached)
	w.bool(p.has_external_link_settings)
	if p.has_external_link_settings {
		w.bool(p.external_link_settings)
	}
}

pub fn (mut p EducationSettingsPacket) decode_payload(mut r serializer.Reader) ! {
	p.code_builder_uri = r.read_string()!
	p.code_builder_title = r.read_string()!
	p.can_resize_code_builder = r.bool()!
	p.disable_legacy_title = r.bool()!
	p.post_process_filter = r.read_string()!
	p.screenshot_border_path = r.read_string()!
	p.has_entity_capabilities = r.bool()!
	if p.has_entity_capabilities {
		p.entity_capabilities = r.bool()!
	}
	p.has_override_uri = r.bool()!
	if p.has_override_uri {
		p.override_uri = r.read_string()!
	}
	p.quiz_attached = r.bool()!
	p.has_external_link_settings = r.bool()!
	if p.has_external_link_settings {
		p.external_link_settings = r.bool()!
	}
}
