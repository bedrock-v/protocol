module packets

import serializer

pub struct SetDefaultGameTypePacket {
pub mut:
	gamemode i32
}

pub fn (p &SetDefaultGameTypePacket) pid() u16 {
	return 105
}

pub fn (p &SetDefaultGameTypePacket) name() string {
	return 'SetDefaultGameTypePacket'
}

pub fn (p &SetDefaultGameTypePacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &SetDefaultGameTypePacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint32(u32(p.gamemode))
}

pub fn (mut p SetDefaultGameTypePacket) decode_payload(mut r serializer.Reader) ! {
	p.gamemode = r.read_varint32()!
}
