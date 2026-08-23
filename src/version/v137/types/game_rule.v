module types

import protocol.serializer

pub struct GameRuleBool {
pub mut:
	value bool
}

pub struct GameRuleInt {
pub mut:
	value u32
}

pub struct GameRuleFloat {
pub mut:
	value f32
}

pub type GameRuleValue = GameRuleBool | GameRuleFloat | GameRuleInt

pub struct GameRule {
pub mut:
	name  string
	value GameRuleValue = GameRuleBool{}
}

pub fn (t GameRule) encode(mut w serializer.Writer) {
	w.write_string(t.name)
	match t.value {
		GameRuleBool {
			w.write_varuint32(1)
			w.bool(t.value.value)
		}
		GameRuleInt {
			w.write_varuint32(2)
			w.write_varuint32(t.value.value)
		}
		GameRuleFloat {
			w.write_varuint32(3)
			w.le_f32(t.value.value)
		}
	}
}

pub fn GameRule.decode(mut r serializer.Reader) !GameRule {
	name := r.read_string()!
	rule_type := r.read_varuint32()!
	mut value := GameRuleValue(GameRuleBool{})
	if rule_type == 1 {
		value = GameRuleBool{
			value: r.bool()!
		}
	} else if rule_type == 2 {
		value = GameRuleInt{
			value: r.read_varuint32()!
		}
	} else if rule_type == 3 {
		value = GameRuleFloat{
			value: r.le_f32()!
		}
	} else {
		return error('invalid game rule type ${rule_type}')
	}
	return GameRule{
		name:  name
		value: value
	}
}

pub fn write_game_rules(mut w serializer.Writer, rules []GameRule) {
	w.write_varuint32(u32(rules.len))
	for rule in rules {
		rule.encode(mut w)
	}
}

pub fn read_game_rules(mut r serializer.Reader) ![]GameRule {
	count := r.read_count()!
	mut rules := []GameRule{cap: serializer.prealloc(count)}
	for _ in 0 .. count {
		rules << GameRule.decode(mut r)!
	}
	return rules
}
