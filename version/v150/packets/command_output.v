module packets

import protocol.serializer
import protocol.version.v137.types

pub struct CommandOriginData {
pub mut:
	origin_type u32
	uuid        types.Uuid
	request_id  string
	varlong1    i64
}

pub fn (t CommandOriginData) encode(mut w serializer.Writer) {
	w.write_varuint32(t.origin_type)
	t.uuid.encode(mut w)
	w.write_string(t.request_id)
	if t.origin_type == 3 || t.origin_type == 4 {
		w.write_varint64(t.varlong1)
	}
}

pub fn CommandOriginData.decode(mut r serializer.Reader) !CommandOriginData {
	mut t := CommandOriginData{}
	t.origin_type = r.read_varuint32()!
	t.uuid = types.Uuid.decode(mut r)!
	t.request_id = r.read_string()!
	if t.origin_type == 3 || t.origin_type == 4 {
		t.varlong1 = r.read_varint64()!
	}
	return t
}

pub struct CommandOutputMessage {
pub mut:
	is_internal bool
	message_id  string
	parameters  []string
}

pub struct CommandOutputPacket {
pub mut:
	origin_data    CommandOriginData
	output_type    u8
	success_count  u32
	messages       []CommandOutputMessage
	unknown_string string
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
	w.u8(p.output_type)
	w.write_varuint32(p.success_count)
	w.write_varuint32(u32(p.messages.len))
	for m in p.messages {
		w.bool(m.is_internal)
		w.write_string(m.message_id)
		w.write_varuint32(u32(m.parameters.len))
		for param in m.parameters {
			w.write_string(param)
		}
	}
	if p.output_type == 4 {
		w.write_string(p.unknown_string)
	}
}

pub fn (mut p CommandOutputPacket) decode_payload(mut r serializer.Reader) ! {
	p.origin_data = CommandOriginData.decode(mut r)!
	p.output_type = r.u8()!
	p.success_count = r.read_varuint32()!
	message_count := r.read_count()!
	p.messages = []CommandOutputMessage{cap: serializer.prealloc(message_count)}
	for _ in 0 .. message_count {
		mut m := CommandOutputMessage{}
		m.is_internal = r.bool()!
		m.message_id = r.read_string()!
		param_count := r.read_count()!
		m.parameters = []string{cap: serializer.prealloc(param_count)}
		for _ in 0 .. param_count {
			m.parameters << r.read_string()!
		}
		p.messages << m
	}
	if p.output_type == 4 {
		p.unknown_string = r.read_string()!
	}
}
