module packets

import protocol.serializer
import protocol.version.v291.enums as enums_291
import protocol.version.v291.types as types_291

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
	count := r.read_count()!
	t.constraints = []u8{cap: serializer.prealloc(count)}
	for _ in 0 .. count {
		t.constraints << r.u8()!
	}
	return t
}

pub struct AvailableCommandsPacket {
pub mut:
	enum_values []string
	postfixes   []string
	enums       []types_291.CommandEnumIndexed
	commands    []CommandData
	soft_enums  []types_291.CommandEnumData
	constraints []CommandEnumConstraintData
}

pub fn (p &AvailableCommandsPacket) pid() u16 {
	return 76
}

pub fn (p &AvailableCommandsPacket) name() string {
	return 'AvailableCommandsPacket'
}

pub fn (p &AvailableCommandsPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &AvailableCommandsPacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint32(u32(p.enum_values.len))
	for value in p.enum_values {
		w.write_string(value)
	}
	w.write_varuint32(u32(p.postfixes.len))
	for postfix in p.postfixes {
		w.write_string(postfix)
	}
	index_size := types_291.enum_index_size(p.enum_values.len)
	w.write_varuint32(u32(p.enums.len))
	for e in p.enums {
		e.encode(mut w, index_size)
	}
	w.write_varuint32(u32(p.commands.len))
	for command in p.commands {
		command.encode(mut w)
	}
	w.write_varuint32(u32(p.soft_enums.len))
	for soft_enum in p.soft_enums {
		soft_enum.encode(mut w)
	}
	w.write_varuint32(u32(p.constraints.len))
	for constraint in p.constraints {
		constraint.encode(mut w)
	}
}

pub fn (mut p AvailableCommandsPacket) decode_payload(mut r serializer.Reader) ! {
	value_count := r.read_count()!
	p.enum_values = []string{cap: serializer.prealloc(value_count)}
	for _ in 0 .. value_count {
		p.enum_values << r.read_string()!
	}
	postfix_count := r.read_count()!
	p.postfixes = []string{cap: serializer.prealloc(postfix_count)}
	for _ in 0 .. postfix_count {
		p.postfixes << r.read_string()!
	}
	index_size := types_291.enum_index_size(p.enum_values.len)
	enum_count := r.read_count()!
	p.enums = []types_291.CommandEnumIndexed{cap: serializer.prealloc(enum_count)}
	for _ in 0 .. enum_count {
		p.enums << types_291.CommandEnumIndexed.decode(mut r, index_size)!
	}
	command_count := r.read_count()!
	p.commands = []CommandData{cap: serializer.prealloc(command_count)}
	for _ in 0 .. command_count {
		p.commands << CommandData.decode(mut r)!
	}
	soft_enum_count := r.read_count()!
	p.soft_enums = []types_291.CommandEnumData{cap: serializer.prealloc(soft_enum_count)}
	for _ in 0 .. soft_enum_count {
		p.soft_enums << types_291.CommandEnumData.decode(mut r, true)!
	}
	constraint_count := r.read_count()!
	p.constraints = []CommandEnumConstraintData{cap: serializer.prealloc(constraint_count)}
	for _ in 0 .. constraint_count {
		p.constraints << CommandEnumConstraintData.decode(mut r)!
	}
}
