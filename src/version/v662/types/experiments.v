module types

import protocol.serializer

pub struct Experiment {
pub mut:
	name    string
	enabled bool
}

pub fn (t Experiment) encode(mut w serializer.Writer) {
	w.write_string(t.name)
	w.bool(t.enabled)
}

pub fn Experiment.decode(mut r serializer.Reader) !Experiment {
	return Experiment{
		name:    r.read_string()!
		enabled: r.bool()!
	}
}

pub struct Experiments {
pub mut:
	experiments  []Experiment
	ever_toggled bool
}

pub fn (t Experiments) encode(mut w serializer.Writer) {
	w.le_u32(u32(t.experiments.len))
	for e in t.experiments {
		e.encode(mut w)
	}
	w.bool(t.ever_toggled)
}

pub fn Experiments.decode(mut r serializer.Reader) !Experiments {
	count := int(r.le_u32()!)
	mut items := []Experiment{cap: count}
	for _ in 0 .. count {
		items << Experiment.decode(mut r)!
	}
	return Experiments{
		experiments:  items
		ever_toggled: r.bool()!
	}
}
