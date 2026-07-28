module packets

import protocol.serializer
import protocol.version.v137.types

pub struct GameRulesChangedPacket {
pub mut:
	game_rules []types.GameRule
}

pub fn (p &GameRulesChangedPacket) pid() u16 {
	return 72
}

pub fn (p &GameRulesChangedPacket) name() string {
	return 'GameRulesChangedPacket'
}

pub fn (p &GameRulesChangedPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &GameRulesChangedPacket) encode_payload(mut w serializer.Writer) {
	types.write_game_rules(mut w, p.game_rules)
}

pub fn (mut p GameRulesChangedPacket) decode_payload(mut r serializer.Reader) ! {
	p.game_rules = types.read_game_rules(mut r)!
}
