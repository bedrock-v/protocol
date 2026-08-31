module packets

import protocol.serializer

pub struct CommandRequestPacket {
pub mut:
	command     string
	origin_data CommandOriginData
	is_internal bool
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
	p.origin_data.encode(mut w)
	w.bool(p.is_internal)
}

pub fn (mut p CommandRequestPacket) decode_payload(mut r serializer.Reader) ! {
	p.command = r.read_string()!
	p.origin_data = CommandOriginData.decode(mut r)!
	p.is_internal = r.bool()!
}
