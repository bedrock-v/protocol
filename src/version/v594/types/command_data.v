module types

import protocol.serializer
import protocol.version.v291.enums as enums_291
import protocol.version.v340.types as types_340

pub struct ChainedSubCommandValue {
pub mut:
	first  u16
	second u16
}

pub struct ChainedSubCommandData {
pub mut:
	name   string
	values []ChainedSubCommandValue
}

pub fn (t ChainedSubCommandData) encode(mut w serializer.Writer) {
	w.write_string(t.name)
	w.write_varuint32(u32(t.values.len))
	for value in t.values {
		w.le_u16(value.first)
		w.le_u16(value.second)
	}
}

pub fn ChainedSubCommandData.decode(mut r serializer.Reader) !ChainedSubCommandData {
	mut t := ChainedSubCommandData{}
	t.name = r.read_string()!
	count := int(r.read_varuint32()!)
	t.values = []ChainedSubCommandValue{cap: count}
	for _ in 0 .. count {
		t.values << ChainedSubCommandValue{
			first:  r.le_u16()!
			second: r.le_u16()!
		}
	}
	return t
}

pub struct CommandOverloadData {
pub mut:
	chaining  bool
	overloads []types_340.CommandParamData
}

pub struct CommandData {
pub mut:
	name               string
	description        string
	flags              u16
	permission         enums_291.CommandPermission
	alias_index        i32 = -1
	subcommand_indices []u16
	overloads          []CommandOverloadData
}

pub fn (t CommandData) encode(mut w serializer.Writer) {
	w.write_string(t.name)
	w.write_string(t.description)
	w.le_u16(t.flags)
	t.permission.encode(mut w)
	w.le_i32(t.alias_index)
	w.write_varuint32(u32(t.subcommand_indices.len))
	for index in t.subcommand_indices {
		w.le_u16(index)
	}
	w.write_varuint32(u32(t.overloads.len))
	for overload in t.overloads {
		w.bool(overload.chaining)
		w.write_varuint32(u32(overload.overloads.len))
		for param in overload.overloads {
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
	subcommand_count := int(r.read_varuint32()!)
	t.subcommand_indices = []u16{cap: subcommand_count}
	for _ in 0 .. subcommand_count {
		t.subcommand_indices << r.le_u16()!
	}
	overload_count := int(r.read_varuint32()!)
	t.overloads = []CommandOverloadData{cap: overload_count}
	for _ in 0 .. overload_count {
		chaining := r.bool()!
		param_count := int(r.read_varuint32()!)
		mut params := []types_340.CommandParamData{cap: param_count}
		for _ in 0 .. param_count {
			params << types_340.CommandParamData.decode(mut r)!
		}
		t.overloads << CommandOverloadData{
			chaining:  chaining
			overloads: params
		}
	}
	return t
}
