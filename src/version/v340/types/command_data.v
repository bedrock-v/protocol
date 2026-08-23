module types

import protocol.serializer
import protocol.version.v291.enums

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
	flags       u8
	permission  enums.CommandPermission
	alias_index i32 = -1
	overloads   [][]CommandParamData
}

pub fn (t CommandData) encode(mut w serializer.Writer) {
	w.write_string(t.name)
	w.write_string(t.description)
	w.u8(t.flags)
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
	t.flags = r.u8()!
	t.permission = enums.CommandPermission.decode(mut r)!
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
