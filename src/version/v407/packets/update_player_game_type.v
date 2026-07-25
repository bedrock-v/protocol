module packets

import serializer
import version.v291.enums as enums_291

pub struct UpdatePlayerGameTypePacket {
pub mut:
	game_type enums_291.GameType
	entity_id i64
}

pub fn (p &UpdatePlayerGameTypePacket) pid() u16 {
	return 151
}

pub fn (p &UpdatePlayerGameTypePacket) name() string {
	return 'UpdatePlayerGameTypePacket'
}

pub fn (p &UpdatePlayerGameTypePacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &UpdatePlayerGameTypePacket) encode_payload(mut w serializer.Writer) {
	p.game_type.encode(mut w)
	w.write_varint64(p.entity_id)
}

pub fn (mut p UpdatePlayerGameTypePacket) decode_payload(mut r serializer.Reader) ! {
	p.game_type = enums_291.GameType.decode(mut r)!
	p.entity_id = r.read_varint64()!
}
