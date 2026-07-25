module packets

import serializer
import version.v662.types

pub struct CommandRequestPacket {
pub mut:
	command        string
	command_origin types.CommandOriginData
	internal       bool
	version        i32
}

pub fn (p &CommandRequestPacket) pid() u16 { return 77 }

pub fn (p &CommandRequestPacket) name() string { return 'CommandRequestPacket' }

pub fn (p &CommandRequestPacket) can_be_sent_before_login() bool { return false }

pub fn (p &CommandRequestPacket) encode_payload(mut w serializer.Writer) {
	w.write_string(p.command)
	p.command_origin.encode(mut w)
	w.bool(p.internal)
	w.write_varint32(p.version)
}

pub fn (mut p CommandRequestPacket) decode_payload(mut r serializer.Reader) ! {
	p.command = r.read_string()!
	p.command_origin = types.CommandOriginData.decode(mut r)!
	p.internal = r.bool()!
	p.version = r.read_varint32()!
}
