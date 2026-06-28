module protocol

import serializer

pub struct EducationSettingsAgentCapabilities {
pub mut:
	can_modify_blocks ?bool
}

pub struct EducationSettingsExternalLinkSettings {
pub mut:
	url          string
	display_name string
}

pub struct EducationSettingsPacket {
pub mut:
	code_builder_default_uri      string
	code_builder_title            string
	can_resize_code_builder       bool
	disable_legacy_title_bar      bool
	post_process_filter           string
	screenshot_border_resource_path string
	agent_capabilities            ?EducationSettingsAgentCapabilities
	code_builder_override_uri     ?string
	has_quiz                      bool
	link_settings                 ?EducationSettingsExternalLinkSettings
}

pub fn (p &EducationSettingsPacket) pid() u16 {
	return education_settings_packet
}

pub fn (p &EducationSettingsPacket) name() string {
	return 'EducationSettingsPacket'
}

pub fn (p &EducationSettingsPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p EducationSettingsPacket) decode_payload(mut r serializer.Reader) ! {
	p.code_builder_default_uri = r.read_string()!
	p.code_builder_title = r.read_string()!
	p.can_resize_code_builder = r.bool()!
	p.disable_legacy_title_bar = r.bool()!
	p.post_process_filter = r.read_string()!
	p.screenshot_border_resource_path = r.read_string()!
	if r.bool()! {
		mut cap := EducationSettingsAgentCapabilities{}
		if r.bool()! {
			cap.can_modify_blocks = r.bool()!
		}
		p.agent_capabilities = cap
	}
	if r.bool()! {
		p.code_builder_override_uri = r.read_string()!
	}
	p.has_quiz = r.bool()!
	if r.bool()! {
		p.link_settings = EducationSettingsExternalLinkSettings{
			url:          r.read_string()!
			display_name: r.read_string()!
		}
	}
}

pub fn (p &EducationSettingsPacket) encode_payload(mut w serializer.Writer) {
	w.write_string(p.code_builder_default_uri)
	w.write_string(p.code_builder_title)
	w.bool(p.can_resize_code_builder)
	w.bool(p.disable_legacy_title_bar)
	w.write_string(p.post_process_filter)
	w.write_string(p.screenshot_border_resource_path)
	if cap := p.agent_capabilities {
		w.bool(true)
		if mb := cap.can_modify_blocks {
			w.bool(true)
			w.bool(mb)
		} else {
			w.bool(false)
		}
	} else {
		w.bool(false)
	}
	if uri := p.code_builder_override_uri {
		w.bool(true)
		w.write_string(uri)
	} else {
		w.bool(false)
	}
	w.bool(p.has_quiz)
	if ls := p.link_settings {
		w.bool(true)
		w.write_string(ls.url)
		w.write_string(ls.display_name)
	} else {
		w.bool(false)
	}
}
