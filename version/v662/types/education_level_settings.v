module types

import protocol.serializer

pub struct ExternalLinkSettings {
pub mut:
	url          string
	display_name string
}

pub fn (t ExternalLinkSettings) encode(mut w serializer.Writer) {
	w.write_string(t.url)
	w.write_string(t.display_name)
}

pub fn ExternalLinkSettings.decode(mut r serializer.Reader) !ExternalLinkSettings {
	return ExternalLinkSettings{
		url:          r.read_string()!
		display_name: r.read_string()!
	}
}

pub struct EducationLevelSettings {
pub mut:
	code_builder_default_uri        string
	code_builder_title              string
	code_builder_resizable          bool
	disable_legacy_title_bar        bool
	post_process_filter             string
	screenshot_border_resource_path string
	agent_capabilities              ?bool
	code_builder_override_uri       ?string
	has_quiz                        bool
	external_link_settings          ?ExternalLinkSettings
}

pub fn (t EducationLevelSettings) encode(mut w serializer.Writer) {
	w.write_string(t.code_builder_default_uri)
	w.write_string(t.code_builder_title)
	w.bool(t.code_builder_resizable)
	w.bool(t.disable_legacy_title_bar)
	w.write_string(t.post_process_filter)
	w.write_string(t.screenshot_border_resource_path)
	if v := t.agent_capabilities {
		w.bool(true)
		w.bool(v)
	} else {
		w.bool(false)
	}
	if v := t.code_builder_override_uri {
		w.bool(true)
		w.write_string(v)
	} else {
		w.bool(false)
	}
	w.bool(t.has_quiz)
	if v := t.external_link_settings {
		w.bool(true)
		v.encode(mut w)
	} else {
		w.bool(false)
	}
}

pub fn EducationLevelSettings.decode(mut r serializer.Reader) !EducationLevelSettings {
	mut t := EducationLevelSettings{}
	t.code_builder_default_uri = r.read_string()!
	t.code_builder_title = r.read_string()!
	t.code_builder_resizable = r.bool()!
	t.disable_legacy_title_bar = r.bool()!
	t.post_process_filter = r.read_string()!
	t.screenshot_border_resource_path = r.read_string()!
	if r.bool()! {
		t.agent_capabilities = r.bool()!
	}
	if r.bool()! {
		t.code_builder_override_uri = r.read_string()!
	}
	t.has_quiz = r.bool()!
	if r.bool()! {
		t.external_link_settings = ExternalLinkSettings.decode(mut r)!
	}
	return t
}
