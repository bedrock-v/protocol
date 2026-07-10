module protocol


pub fn (mut r Reader) read_game_rules(is_start_game bool) ![]GameRule {
	count := int(r.read_varuint32()!)
	mut rules := []GameRule{cap: count}
	for _ in 0 .. count {
		name := r.read_string()!
		is_player_modifiable := r.bool()!
		type_id := r.read_varuint32()!
		value := r.read_game_rule_value(type_id, is_start_game)!
		rules << GameRule{
			name:                 name
			is_player_modifiable: is_player_modifiable
			value:                value
		}
	}
	return rules
}

pub fn (mut r Reader) read_game_rule_value(type_id u32, is_start_game bool) !GameRuleValue {
	match type_id {
		game_rule_type_bool {
			return GameRuleValue(BoolRule{
				value: r.bool()!
			})
		}
		game_rule_type_int {
			value := if is_start_game { r.read_varuint32()! } else { r.le_u32()! }
			return GameRuleValue(IntRule{
				value: value
			})
		}
		game_rule_type_float {
			return GameRuleValue(FloatRule{
				value: r.le_f32()!
			})
		}
		else {
			return error('unknown gamerule type ${type_id}')
		}
	}
}

pub fn (mut w Writer) write_game_rules(rules []GameRule, is_start_game bool) {
	w.write_varuint32(u32(rules.len))
	for rule in rules {
		w.write_string(rule.name)
		w.bool(rule.is_player_modifiable)
		w.write_varuint32(game_rule_type_id(rule.value))
		w.write_game_rule_value(rule.value, is_start_game)
	}
}

pub fn (mut w Writer) write_game_rule_value(value GameRuleValue, is_start_game bool) {
	match value {
		BoolRule {
			w.bool(value.value)
		}
		IntRule {
			if is_start_game {
				w.write_varuint32(value.value)
			} else {
				w.le_u32(value.value)
			}
		}
		FloatRule {
			w.le_f32(value.value)
		}
	}
}
