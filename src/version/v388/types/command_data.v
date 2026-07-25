module types

import serializer

pub enum CommandEnumConstraint as u8 {
	cheats_enabled       = 0
	operator_permissions = 1
	host_permissions     = 2
	allow_aliases        = 3
}

pub struct CommandEnumConstraintData {
pub mut:
	value_index i32
	enum_index  i32
	constraints []CommandEnumConstraint
}

pub fn (t CommandEnumConstraintData) encode(mut w serializer.Writer) {
	w.le_i32(t.value_index)
	w.le_i32(t.enum_index)
	w.write_varuint32(u32(t.constraints.len))
	for constraint in t.constraints {
		w.u8(u8(constraint))
	}
}

pub fn CommandEnumConstraintData.decode(mut r serializer.Reader) !CommandEnumConstraintData {
	mut t := CommandEnumConstraintData{}
	t.value_index = r.le_i32()!
	t.enum_index = r.le_i32()!
	count := int(r.read_varuint32()!)
	t.constraints = []CommandEnumConstraint{cap: count}
	for _ in 0 .. count {
		t.constraints << unsafe { CommandEnumConstraint(r.u8()!) }
	}
	return t
}
