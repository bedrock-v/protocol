module protocol


pub fn (mut r Reader) read_experiments() !Experiments {
	mut e := Experiments{
		entries: []ExperimentEntry{}
	}
	count := r.le_u32()!
	for _ in 0 .. count {
		e.entries << ExperimentEntry{
			name:    r.read_string()!
			enabled: r.bool()!
		}
	}
	e.has_previously_used = r.bool()!
	return e
}

pub fn (mut w Writer) write_experiments(e Experiments) {
	w.le_u32(u32(e.entries.len))
	for entry in e.entries {
		w.write_string(entry.name)
		w.bool(entry.enabled)
	}
	w.bool(e.has_previously_used)
}
