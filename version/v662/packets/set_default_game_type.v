module packets

import protocol.serializer
import protocol.version.v662.enums

pub struct SetDefaultGameTypePacket {
pub mut:
	default_game_type enums.GameType
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
	p.default_game_type.encode(mut w)
}

pub fn (mut p SetDefaultGameTypePacket) decode_payload(mut r serializer.Reader) ! {
	p.default_game_type = enums.GameType.decode(mut r)!
}
