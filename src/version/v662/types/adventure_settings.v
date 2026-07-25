module types

import serializer

pub struct AdventureSettings {
pub mut:
	no_pvm          bool
	no_mvp          bool
	immutable_world bool
	show_name_tags  bool
	auto_jump       bool
}

pub fn (t AdventureSettings) encode(mut w serializer.Writer) {
	w.bool(t.no_pvm)
	w.bool(t.no_mvp)
	w.bool(t.immutable_world)
	w.bool(t.show_name_tags)
	w.bool(t.auto_jump)
}

pub fn AdventureSettings.decode(mut r serializer.Reader) !AdventureSettings {
	return AdventureSettings{
		no_pvm:          r.bool()!
		no_mvp:          r.bool()!
		immutable_world: r.bool()!
		show_name_tags:  r.bool()!
		auto_jump:       r.bool()!
	}
}
