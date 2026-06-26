module src

import src.serializer
import src.types

pub struct CommandOutputMessage {
pub mut:
	message_id  string
	is_internal bool
	parameters  []string
}

pub struct CommandOutputPacket {
pub mut:
	origin_data   types.CommandOriginData
	output_type   string
	success_count u32
	messages      []CommandOutputMessage
	data          ?string
}

pub fn (p &CommandOutputPacket) pid() u16 {
	return command_output_packet
}

pub fn (p &CommandOutputPacket) name() string {
	return 'CommandOutputPacket'
}

pub fn (p &CommandOutputPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p CommandOutputPacket) decode_payload(mut r serializer.Reader) ! {
	p.origin_data = r.read_command_origin_data()!
	p.output_type = r.read_string()!
	p.success_count = r.read_varuint32()!
	count := r.read_varuint32()!
	p.messages = []CommandOutputMessage{}
	for _ in 0 .. count {
		mut msg := CommandOutputMessage{
			message_id:  r.read_string()!
			is_internal: r.bool()!
		}
		param_count := r.read_varuint32()!
		msg.parameters = []string{}
		for _ in 0 .. param_count {
			msg.parameters << r.read_string()!
		}
		p.messages << msg
	}
	if r.bool()! {
		p.data = r.read_string()!
	} else {
		p.data = none
	}
}

pub fn (p &CommandOutputPacket) encode_payload(mut w serializer.Writer) {
	w.write_command_origin_data(p.origin_data)
	w.write_string(p.output_type)
	w.write_varuint32(p.success_count)
	w.write_varuint32(u32(p.messages.len))
	for msg in p.messages {
		w.write_string(msg.message_id)
		w.bool(msg.is_internal)
		w.write_varuint32(u32(msg.parameters.len))
		for param in msg.parameters {
			w.write_string(param)
		}
	}
	if d := p.data {
		w.bool(true)
		w.write_string(d)
	} else {
		w.bool(false)
	}
}
