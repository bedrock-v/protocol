module types

import protocol.serializer
import protocol.version.v291.enums as enums_291

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
	value_index := r.le_i32()!
	enum_index := r.le_i32()!
	count := r.read_count()!
	mut constraints := []CommandEnumConstraint{cap: serializer.prealloc(count)}
	for _ in 0 .. count {
		constraints << unsafe { CommandEnumConstraint(r.u8()!) }
	}
	return CommandEnumConstraintData{
		value_index: value_index
		enum_index:  enum_index
		constraints: constraints
	}
}

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
	w.u8(u8(t.permission))
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
	name := r.read_string()!
	description := r.read_string()!
	flags := r.le_u16()!
	permission := unsafe { enums_291.CommandPermission(r.u8()!) }
	alias_index := r.le_i32()!
	overload_count := r.read_count()!
	mut overloads := [][]CommandParamData{cap: serializer.prealloc(overload_count)}
	for _ in 0 .. overload_count {
		param_count := r.read_count()!
		mut params := []CommandParamData{cap: serializer.prealloc(param_count)}
		for _ in 0 .. param_count {
			params << CommandParamData.decode(mut r)!
		}
		overloads << params
	}
	return CommandData{
		name:        name
		description: description
		flags:       flags
		permission:  permission
		alias_index: alias_index
		overloads:   overloads
	}
}
