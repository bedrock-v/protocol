module types

import protocol.serializer

pub struct GameRuleBool {
pub mut:
	value bool
}

pub struct GameRuleInt {
pub mut:
	value i32
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
			w.le_i32(t.value)
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
		1 { return GameRuleBool{
				value: r.bool()!
			} }
		2 { return GameRuleInt{
				value: r.le_i32()!
			} }
		3 { return GameRuleFloat{
				value: r.le_f32()!
			} }
		else { return error('invalid GameRuleType ${d}') }
	}
}

pub struct GameRuleChanged {
pub mut:
	rule_name                 string
	can_be_modified_by_player bool
	rule_type                 GameRuleType = GameRuleBool{}
}

pub fn (t GameRuleChanged) encode(mut w serializer.Writer) {
	w.write_string(t.rule_name)
	w.bool(t.can_be_modified_by_player)
	t.rule_type.encode(mut w)
}

pub fn GameRuleChanged.decode(mut r serializer.Reader) !GameRuleChanged {
	return GameRuleChanged{
		rule_name:                 r.read_string()!
		can_be_modified_by_player: r.bool()!
		rule_type:                 GameRuleType.decode(mut r)!
	}
}

pub struct GameRulesChangedPacketData {
pub mut:
	rules_list []GameRuleChanged
}

pub fn (t GameRulesChangedPacketData) encode(mut w serializer.Writer) {
	w.write_varuint32(u32(t.rules_list.len))
	for e in t.rules_list {
		e.encode(mut w)
	}
}

pub fn GameRulesChangedPacketData.decode(mut r serializer.Reader) !GameRulesChangedPacketData {
	count := int(r.read_varuint32()!)
	mut items := []GameRuleChanged{cap: count}
	for _ in 0 .. count {
		items << GameRuleChanged.decode(mut r)!
	}
	return GameRulesChangedPacketData{
		rules_list: items
	}
}
