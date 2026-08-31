module packets

import protocol.serializer
import protocol.version.v662.types
import protocol.version.v662.enums

pub struct OutputMessagesEntry {
pub mut:
	successful bool
	message_id string
	parameters []string
}

pub fn (e OutputMessagesEntry) encode(mut w serializer.Writer) {
	w.bool(e.successful)
	w.write_string(e.message_id)
	w.write_varuint32(u32(e.parameters.len))
	for s in e.parameters {
		w.write_string(s)
	}
}

pub fn OutputMessagesEntry.decode(mut r serializer.Reader) !OutputMessagesEntry {
	mut e := OutputMessagesEntry{}
	e.successful = r.bool()!
	e.message_id = r.read_string()!
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
	output_type     enums.CommandOutputType = enums.CommandOutputNone{}
	success_count   u32
	output_messages []OutputMessagesEntry
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
	w.i8(p.output_type.id())
	w.write_varuint32(p.success_count)
	w.write_varuint32(u32(p.output_messages.len))
	for e in p.output_messages {
		e.encode(mut w)
	}
	p.output_type.encode_payload(mut w)
}

pub fn (mut p CommandOutputPacket) decode_payload(mut r serializer.Reader) ! {
	p.origin_data = types.CommandOriginData.decode(mut r)!
	type_id := r.i8()!
	p.success_count = r.read_varuint32()!
	count := r.read_count()!
	p.output_messages = []OutputMessagesEntry{cap: serializer.prealloc(count)}
	for _ in 0 .. count {
		p.output_messages << OutputMessagesEntry.decode(mut r)!
	}
	p.output_type = enums.CommandOutputType.decode_payload(type_id, mut r)!
}
