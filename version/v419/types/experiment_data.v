module types

import protocol.serializer

pub struct ExperimentData {
pub mut:
	name    string
	enabled bool
}

pub fn (t ExperimentData) encode(mut w serializer.Writer) {
	w.write_string(t.name)
	w.bool(t.enabled)
}

pub fn ExperimentData.decode(mut r serializer.Reader) !ExperimentData {
	return ExperimentData{
		name:    r.read_string()!
		enabled: r.bool()!
	}
}

pub fn write_experiments(mut w serializer.Writer, experiments []ExperimentData) {
	w.le_u32(u32(experiments.len))
	for experiment in experiments {
		experiment.encode(mut w)
	}
}

pub fn read_experiments(mut r serializer.Reader) ![]ExperimentData {
	count := int(r.le_u32()!)
	mut experiments := []ExperimentData{cap: serializer.prealloc(count)}
	for _ in 0 .. count {
		experiments << ExperimentData.decode(mut r)!
	}
	return experiments
}
