module packets

import serializer
import version.v291.types

pub struct GameRulesChangedPacket {
pub mut:
	game_rules []types.GameRuleData
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
	w.write_varuint32(u32(p.game_rules.len))
	for rule in p.game_rules {
		rule.encode(mut w)
	}
}

pub fn (mut p GameRulesChangedPacket) decode_payload(mut r serializer.Reader) ! {
	count := int(r.read_varuint32()!)
	p.game_rules = []types.GameRuleData{cap: count}
	for _ in 0 .. count {
		p.game_rules << types.GameRuleData.decode(mut r)!
	}
}
