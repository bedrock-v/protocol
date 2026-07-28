module enums

import protocol.serializer

pub struct CommandOutputNone {}

pub struct CommandOutputLastOutput {}

pub struct CommandOutputSilent {}

pub struct CommandOutputAllOutput {}

pub struct CommandOutputDataSet {
pub mut:
	value string
}

pub type CommandOutputType = CommandOutputAllOutput
	| CommandOutputDataSet
	| CommandOutputLastOutput
	| CommandOutputNone
	| CommandOutputSilent

pub fn (t CommandOutputType) id() i8 {
	return match t {
		CommandOutputNone { i8(0) }
		CommandOutputLastOutput { i8(1) }
		CommandOutputSilent { i8(2) }
		CommandOutputAllOutput { i8(3) }
		CommandOutputDataSet { i8(4) }
	}
}

pub fn (t CommandOutputType) encode_payload(mut w serializer.Writer) {
	match t {
		CommandOutputDataSet { w.write_string(t.value) }
		else {}
	}
}

pub fn CommandOutputType.decode_payload(id i8, mut r serializer.Reader) !CommandOutputType {
	match id {
		0 { return CommandOutputNone{} }
		1 { return CommandOutputLastOutput{} }
		2 { return CommandOutputSilent{} }
		3 { return CommandOutputAllOutput{} }
		4 { return CommandOutputDataSet{
				value: r.read_string()!
			} }
		else { return error('invalid CommandOutputType ${id}') }
	}
}

pub fn (t CommandOutputType) encode(mut w serializer.Writer) {
	w.i8(t.id())
	t.encode_payload(mut w)
}

pub fn CommandOutputType.decode(mut r serializer.Reader) !CommandOutputType {
	d := r.i8()!
	return CommandOutputType.decode_payload(d, mut r)!
}
