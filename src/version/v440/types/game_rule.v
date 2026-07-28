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

pub type GameRuleType = GameRuleBool | GameRuleFloat | GameRuleInt

pub fn (t GameRuleType) encode(mut w serializer.Writer) {
	match t {
		GameRuleBool {
			w.write_varuint32(1)
			w.bool(t.value)
		}
		GameRuleInt {
			w.write_varuint32(2)
			w.write_varuint32(t.value)
		}
		GameRuleFloat {
			w.write_varuint32(3)
			w.le_f32(t.value)
		}
	}
}

pub fn GameRuleType.decode(mut r serializer.Reader) !GameRuleType {
	d := r.read_varuint32()!
	match d {
		1 {
			return GameRuleBool{
				value: r.bool()!
			}
		}
		2 {
			return GameRuleInt{
				value: r.read_varuint32()!
			}
		}
		3 {
			return GameRuleFloat{
				value: r.le_f32()!
			}
		}
		else {
			return error('invalid GameRuleType ${d}')
		}
	}
}

pub struct GameRuleData {
pub mut:
	name      string
	editable  bool
	rule_type GameRuleType = GameRuleBool{}
}

pub fn (t GameRuleData) encode(mut w serializer.Writer) {
	w.write_string(t.name)
	w.bool(t.editable)
	t.rule_type.encode(mut w)
}

pub fn GameRuleData.decode(mut r serializer.Reader) !GameRuleData {
	return GameRuleData{
		name:      r.read_string()!
		editable:  r.bool()!
		rule_type: GameRuleType.decode(mut r)!
	}
}
