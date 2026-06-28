module protocol

import serializer
import types

pub struct CommandRequestPacket {
pub mut:
	command     string
	origin_data types.CommandOriginData
	is_internal bool
	version     string
}

pub fn (p &CommandRequestPacket) pid() u16 {
	return command_request_packet
}

pub fn (p &CommandRequestPacket) name() string {
	return 'CommandRequestPacket'
}

pub fn (p &CommandRequestPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p CommandRequestPacket) decode_payload(mut r serializer.Reader) ! {
	p.command = r.read_string()!
	p.origin_data = r.read_command_origin_data()!
	p.is_internal = r.bool()!
	p.version = r.read_string()!
}

pub fn (p &CommandRequestPacket) encode_payload(mut w serializer.Writer) {
	w.write_string(p.command)
	w.write_command_origin_data(p.origin_data)
	w.bool(p.is_internal)
	w.write_string(p.version)
}
