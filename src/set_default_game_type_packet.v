module src

import src.serializer

pub struct SetDefaultGameTypePacket {
pub mut:
	gamemode int
}

pub fn (p &SetDefaultGameTypePacket) pid() u16 {
	return set_default_game_type_packet
}

pub fn (p &SetDefaultGameTypePacket) name() string {
	return 'SetDefaultGameTypePacket'
}

pub fn (p &SetDefaultGameTypePacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p SetDefaultGameTypePacket) decode_payload(mut r serializer.Reader) ! {
	p.gamemode = int(r.read_varint32()!)
}

pub fn (p &SetDefaultGameTypePacket) encode_payload(mut w serializer.Writer) {
	w.write_varint32(i32(p.gamemode))
}
