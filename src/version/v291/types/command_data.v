module types

import protocol.serializer
import protocol.version.v291.enums

pub const arg_flag_valid = i32(0x100000)
pub const arg_flag_enum = i32(0x200000)
pub const arg_flag_postfix = i32(0x1000000)
pub const arg_flag_soft_enum = i32(0x4000000)

pub struct CommandEnumData {
pub mut:
	name   string
	values []string
	soft   bool
}

pub fn (t CommandEnumData) encode(mut w serializer.Writer) {
	w.write_string(t.name)
	w.write_varuint32(u32(t.values.len))
	for v in t.values {
		w.write_string(v)
	}
}

pub fn CommandEnumData.decode(mut r serializer.Reader, soft bool) !CommandEnumData {
	mut t := CommandEnumData{
		soft: soft
	}
	t.name = r.read_string()!
	count := int(r.read_varuint32()!)
	t.values = []string{cap: count}
	for _ in 0 .. count {
		t.values << r.read_string()!
	}
	return t
}

pub fn enum_index_size(values_len int) int {
	if values_len <= 0x100 {
		return 1
	} else if values_len <= 0x10000 {
		return 2
	}
	return 4
}

pub fn write_enum_index(mut w serializer.Writer, index u32, index_size int) {
	match index_size {
		1 { w.u8(u8(index)) }
		2 { w.le_u16(u16(index)) }
		else { w.le_u32(index) }
	}
}

pub fn read_enum_index(mut r serializer.Reader, index_size int) !u32 {
	match index_size {
		1 { return u32(r.u8()!) }
		2 { return u32(r.le_u16()!) }
		else { return r.le_u32()! }
	}
}

pub struct CommandEnumIndexed {
pub mut:
	name          string
	value_indices []u32
}

pub fn (t CommandEnumIndexed) encode(mut w serializer.Writer, index_size int) {
	w.write_string(t.name)
	w.write_varuint32(u32(t.value_indices.len))
	for idx in t.value_indices {
		write_enum_index(mut w, idx, index_size)
	}
}

pub fn CommandEnumIndexed.decode(mut r serializer.Reader, index_size int) !CommandEnumIndexed {
	mut t := CommandEnumIndexed{}
	t.name = r.read_string()!
	count := int(r.read_varuint32()!)
	t.value_indices = []u32{cap: count}
	for _ in 0 .. count {
		t.value_indices << read_enum_index(mut r, index_size)!
	}
	return t
}

pub struct CommandParamData {
pub mut:
	name     string
	symbol   i32
	optional bool
}

pub fn (t CommandParamData) encode(mut w serializer.Writer) {
	w.write_string(t.name)
	w.le_i32(t.symbol)
	w.bool(t.optional)
}

pub fn CommandParamData.decode(mut r serializer.Reader) !CommandParamData {
	return CommandParamData{
		name:     r.read_string()!
		symbol:   r.le_i32()!
		optional: r.bool()!
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
	overload_count := int(r.read_varuint32()!)
	t.overloads = [][]CommandParamData{cap: overload_count}
	for _ in 0 .. overload_count {
		param_count := int(r.read_varuint32()!)
		mut params := []CommandParamData{cap: param_count}
		for _ in 0 .. param_count {
			params << CommandParamData.decode(mut r)!
		}
		t.overloads << params
	}
	return t
}
