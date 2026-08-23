module packets

import protocol.serializer
import protocol.version.v898.types
import protocol.version.v898.enums

pub struct OutputMessagesEntry {
pub mut:
	message_id string
	internal   bool
	parameters []string
}

pub fn (e OutputMessagesEntry) encode(mut w serializer.Writer) {
	w.write_string(e.message_id)
	w.bool(e.internal)
	w.write_varuint32(u32(e.parameters.len))
	for s in e.parameters {
		w.write_string(s)
	}
}

pub fn OutputMessagesEntry.decode(mut r serializer.Reader) !OutputMessagesEntry {
	mut e := OutputMessagesEntry{}
	e.message_id = r.read_string()!
	e.internal = r.bool()!
	count := r.read_count()!
	e.parameters = []string{cap: serializer.prealloc(count)}
	for _ in 0 .. count {
		e.parameters << r.read_string()!
	}
	return e
}

pub struct CommandOutputPacket {
pub mut:
	origin_data     types.CommandOriginData
	output_type     enums.CommandOutputType
	success_count   u32
	output_messages []OutputMessagesEntry
	data            ?string
}

pub fn (p &CommandOutputPacket) pid() u16 {
	return 79
}

pub fn (p &CommandOutputPacket) name() string {
	return 'CommandOutputPacket'
}

pub fn (p &CommandOutputPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &CommandOutputPacket) encode_payload(mut w serializer.Writer) {
	p.origin_data.encode(mut w)
	p.output_type.encode(mut w)
	w.le_u32(p.success_count)
	w.write_varuint32(u32(p.output_messages.len))
	for e in p.output_messages {
		e.encode(mut w)
	}
	if v := p.data {
		w.bool(true)
		w.write_string(v)
	} else {
		w.bool(false)
	}
}

pub fn (mut p CommandOutputPacket) decode_payload(mut r serializer.Reader) ! {
	p.origin_data = types.CommandOriginData.decode(mut r)!
	p.output_type = enums.CommandOutputType.decode(mut r)!
	p.success_count = r.le_u32()!
	count := r.read_count()!
	p.output_messages = []OutputMessagesEntry{cap: serializer.prealloc(count)}
	for _ in 0 .. count {
		p.output_messages << OutputMessagesEntry.decode(mut r)!
	}
	if r.bool()! {
		p.data = r.read_string()!
	}
}
