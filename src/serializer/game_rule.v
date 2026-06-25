module serializer

import src.types

pub fn (mut r Reader) read_game_rules(is_start_game bool) ![]types.GameRule {
	count := int(r.read_varuint32()!)
	mut rules := []types.GameRule{cap: count}
	for _ in 0 .. count {
		name := r.read_string()!
		is_player_modifiable := r.bool()!
		type_id := r.read_varuint32()!
		value := r.read_game_rule_value(type_id, is_start_game)!
		rules << types.GameRule{
			name:                 name
			is_player_modifiable: is_player_modifiable
			value:                value
		}
	}
	return rules
}

pub fn (mut r Reader) read_game_rule_value(type_id u32, is_start_game bool) !types.GameRuleValue {
	match type_id {
		types.game_rule_type_bool {
			return types.GameRuleValue(types.BoolRule{
				value: r.bool()!
			})
		}
		types.game_rule_type_int {
			value := if is_start_game { r.read_varuint32()! } else { r.le_u32()! }
			return types.GameRuleValue(types.IntRule{
				value: value
			})
		}
		types.game_rule_type_float {
			return types.GameRuleValue(types.FloatRule{
				value: r.le_f32()!
			})
		}
		else {
			return error('unknown gamerule type ${type_id}')
		}
	}
}

pub fn (mut w Writer) write_game_rules(rules []types.GameRule, is_start_game bool) {
	w.write_varuint32(u32(rules.len))
	for rule in rules {
		w.write_string(rule.name)
		w.bool(rule.is_player_modifiable)
		w.write_varuint32(types.game_rule_type_id(rule.value))
		w.write_game_rule_value(rule.value, is_start_game)
	}
}

pub fn (mut w Writer) write_game_rule_value(value types.GameRuleValue, is_start_game bool) {
	match value {
		types.BoolRule {
			w.bool(value.value)
		}
		types.IntRule {
			if is_start_game {
				w.write_varuint32(value.value)
			} else {
				w.le_u32(value.value)
			}
		}
		types.FloatRule {
			w.le_f32(value.value)
		}
	}
}
