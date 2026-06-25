module types

pub const game_rule_type_bool = u32(1)
pub const game_rule_type_int = u32(2)
pub const game_rule_type_float = u32(3)

pub struct BoolRule {
pub mut:
	value bool
}

pub struct IntRule {
pub mut:
	value u32
}

pub struct FloatRule {
pub mut:
	value f32
}

pub type GameRuleValue = BoolRule | FloatRule | IntRule

pub struct GameRule {
pub mut:
	name                 string
	is_player_modifiable bool
	value                GameRuleValue
}

pub fn game_rule_type_id(v GameRuleValue) u32 {
	return match v {
		BoolRule { game_rule_type_bool }
		IntRule { game_rule_type_int }
		FloatRule { game_rule_type_float }
	}
}
