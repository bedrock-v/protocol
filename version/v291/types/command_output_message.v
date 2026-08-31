module types

import protocol.serializer

pub struct CommandOutputMessage {
pub mut:
	internal   bool
	message_id string
	parameters []string
}

pub fn (t CommandOutputMessage) encode(mut w serializer.Writer) {
	w.bool(t.internal)
	w.write_string(t.message_id)
	w.write_varuint32(u32(t.parameters.len))
	for parameter in t.parameters {
		w.write_string(parameter)
	}
}

pub fn CommandOutputMessage.decode(mut r serializer.Reader) !CommandOutputMessage {
	mut t := CommandOutputMessage{}
	t.internal = r.bool()!
	t.message_id = r.read_string()!
	count := r.read_count()!
	t.parameters = []string{cap: serializer.prealloc(count)}
	for _ in 0 .. count {
		t.parameters << r.read_string()!
	}
	return t
}
