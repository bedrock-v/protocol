module packets

import serializer

pub struct SetPlayerGameTypePacket {
pub mut:
	gamemode i32
}

pub fn (p &SetPlayerGameTypePacket) pid() u16 {
	return 62
}

pub fn (p &SetPlayerGameTypePacket) name() string {
	return 'SetPlayerGameTypePacket'
}

pub fn (p &SetPlayerGameTypePacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &SetPlayerGameTypePacket) encode_payload(mut w serializer.Writer) {
	w.write_varint32(p.gamemode)
}

pub fn (mut p SetPlayerGameTypePacket) decode_payload(mut r serializer.Reader) ! {
	p.gamemode = r.read_varint32()!
}
