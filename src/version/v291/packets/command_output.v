module packets

import serializer
import version.v291.types

pub struct CommandOutputPacket {
pub mut:
	command_origin_data types.CommandOriginData
	output_type         u8
	success_count       u32
	messages            []types.CommandOutputMessage
	data                string
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
	p.command_origin_data.encode(mut w)
	w.u8(p.output_type)
	w.write_varuint32(p.success_count)
	w.write_varuint32(u32(p.messages.len))
	for message in p.messages {
		message.encode(mut w)
	}
	if p.output_type == 4 {
		w.write_string(p.data)
	}
}

pub fn (mut p CommandOutputPacket) decode_payload(mut r serializer.Reader) ! {
	p.command_origin_data = types.CommandOriginData.decode(mut r)!
	p.output_type = r.u8()!
	p.success_count = r.read_varuint32()!
	message_count := int(r.read_varuint32()!)
	p.messages = []types.CommandOutputMessage{cap: message_count}
	for _ in 0 .. message_count {
		p.messages << types.CommandOutputMessage.decode(mut r)!
	}
	if p.output_type == 4 {
		p.data = r.read_string()!
	}
}
