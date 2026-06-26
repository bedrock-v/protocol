module types

pub struct ExperimentEntry {
pub mut:
	name    string
	enabled bool
}

pub struct Experiments {
pub mut:
	entries              []ExperimentEntry
	has_previously_used  bool
}
