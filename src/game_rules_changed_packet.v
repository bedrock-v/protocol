module protocol

import serializer
import types

pub struct GameRulesChangedPacket {
pub mut:
	game_rules []types.GameRule
}

pub fn (p &GameRulesChangedPacket) pid() u16 {
	return game_rules_changed_packet
}

pub fn (p &GameRulesChangedPacket) name() string {
	return 'GameRulesChangedPacket'
}

pub fn (p &GameRulesChangedPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p GameRulesChangedPacket) decode_payload(mut r serializer.Reader) ! {
	p.game_rules = r.read_game_rules(false)!
}

pub fn (p &GameRulesChangedPacket) encode_payload(mut w serializer.Writer) {
	w.write_game_rules(p.game_rules, false)
}
