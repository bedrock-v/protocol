module packets

import protocol.serializer
import protocol.version.v291.types

pub struct CommandRequestPacket {
pub mut:
	command             string
	command_origin_data types.CommandOriginData
	internal            bool
}

pub fn (p &CommandRequestPacket) pid() u16 {
	return 77
}

pub fn (p &CommandRequestPacket) name() string {
	return 'CommandRequestPacket'
}

pub fn (p &CommandRequestPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &CommandRequestPacket) encode_payload(mut w serializer.Writer) {
	w.write_string(p.command)
	p.command_origin_data.encode(mut w)
	w.bool(p.internal)
}

pub fn (mut p CommandRequestPacket) decode_payload(mut r serializer.Reader) ! {
	p.command = r.read_string()!
	p.command_origin_data = types.CommandOriginData.decode(mut r)!
	p.internal = r.bool()!
}
