module enums

import serializer

pub enum CommandOutputType {
	@none       = 0
	last_output = 1
	silent      = 2
	all_output  = 3
	data_set    = 4
}

pub fn (e CommandOutputType) wire_name() string {
	return match e {
		.@none { 'none' }
		.last_output { 'lastoutput' }
		.silent { 'silent' }
		.all_output { 'alloutput' }
		.data_set { 'dataset' }
	}
}

pub fn (e CommandOutputType) encode(mut w serializer.Writer) {
	w.write_string(e.wire_name())
}

pub fn CommandOutputType.decode(mut r serializer.Reader) !CommandOutputType {
	s := r.read_string()!
	match s {
		'none' { return CommandOutputType.@none }
		'lastoutput' { return CommandOutputType.last_output }
		'silent' { return CommandOutputType.silent }
		'alloutput' { return CommandOutputType.all_output }
		'dataset' { return CommandOutputType.data_set }
		else { return error('invalid CommandOutputType ${s}') }
	}
}
