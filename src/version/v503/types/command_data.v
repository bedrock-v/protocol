module types

import protocol.serializer
import protocol.version.v291.enums as enums_291

pub struct CommandParamData {
pub mut:
	name     string
	symbol   i32
	optional bool
	options  u8
}

pub fn (t CommandParamData) encode(mut w serializer.Writer) {
	w.write_string(t.name)
	w.le_i32(t.symbol)
	w.bool(t.optional)
	w.u8(t.options)
}

pub fn CommandParamData.decode(mut r serializer.Reader) !CommandParamData {
	return CommandParamData{
		name:     r.read_string()!
		symbol:   r.le_i32()!
		optional: r.bool()!
		options:  r.u8()!
	}
}

pub struct CommandData {
pub mut:
	name        string
	description string
	flags       u16
	permission  enums_291.CommandPermission
	alias_index i32 = -1
	overloads   [][]CommandParamData
}

pub fn (t CommandData) encode(mut w serializer.Writer) {
	w.write_string(t.name)
	w.write_string(t.description)
	w.le_u16(t.flags)
	t.permission.encode(mut w)
	w.le_i32(t.alias_index)
	w.write_varuint32(u32(t.overloads.len))
	for overload in t.overloads {
		w.write_varuint32(u32(overload.len))
		for param in overload {
			param.encode(mut w)
		}
	}
}

pub fn CommandData.decode(mut r serializer.Reader) !CommandData {
	mut t := CommandData{}
	t.name = r.read_string()!
	t.description = r.read_string()!
	t.flags = r.le_u16()!
	t.permission = enums_291.CommandPermission.decode(mut r)!
	t.alias_index = r.le_i32()!
	overload_count := r.read_count()!
	t.overloads = [][]CommandParamData{cap: serializer.prealloc(overload_count)}
	for _ in 0 .. overload_count {
		param_count := r.read_count()!
		mut params := []CommandParamData{cap: serializer.prealloc(param_count)}
		for _ in 0 .. param_count {
			params << CommandParamData.decode(mut r)!
		}
		t.overloads << params
	}
	return t
}

pub struct CommandEnumConstraintData {
pub mut:
	value_index i32
	enum_index  i32
	constraints []u8
}

pub fn (t CommandEnumConstraintData) encode(mut w serializer.Writer) {
	w.le_i32(t.value_index)
	w.le_i32(t.enum_index)
	w.write_varuint32(u32(t.constraints.len))
	for constraint in t.constraints {
		w.u8(constraint)
	}
}

pub fn CommandEnumConstraintData.decode(mut r serializer.Reader) !CommandEnumConstraintData {
	mut t := CommandEnumConstraintData{}
	t.value_index = r.le_i32()!
	t.enum_index = r.le_i32()!
	constraint_count := r.read_count()!
	t.constraints = []u8{cap: serializer.prealloc(constraint_count)}
	for _ in 0 .. constraint_count {
		t.constraints << r.u8()!
	}
	return t
}
