module packets

import serializer
import version.v662.enums

pub struct EnumDataEntry {
pub mut:
	name   string
	values []u32
}

pub struct SubCommandValues {
pub mut:
	index u16
	value u16
}

pub fn (t SubCommandValues) encode(mut w serializer.Writer) {
	w.le_u16(t.index)
	w.le_u16(t.value)
}

pub fn SubCommandValues.decode(mut r serializer.Reader) !SubCommandValues {
	return SubCommandValues{
		index: r.le_u16()!
		value: r.le_u16()!
	}
}

pub struct ParameterDataEntry {
pub mut:
	name         string
	parse_symbol u32
	is_optional  bool
	options      i8
}

pub fn (t ParameterDataEntry) encode(mut w serializer.Writer) {
	w.write_string(t.name)
	w.le_u32(t.parse_symbol)
	w.bool(t.is_optional)
	w.i8(t.options)
}

pub fn ParameterDataEntry.decode(mut r serializer.Reader) !ParameterDataEntry {
	return ParameterDataEntry{
		name:         r.read_string()!
		parse_symbol: r.le_u32()!
		is_optional:  r.bool()!
		options:      r.i8()!
	}
}

pub struct OverloadsEntry {
pub mut:
	is_chaining    bool
	parameter_data []ParameterDataEntry
}

pub fn (t OverloadsEntry) encode(mut w serializer.Writer) {
	w.bool(t.is_chaining)
	w.write_varuint32(u32(t.parameter_data.len))
	for e in t.parameter_data {
		e.encode(mut w)
	}
}

pub fn OverloadsEntry.decode(mut r serializer.Reader) !OverloadsEntry {
	mut t := OverloadsEntry{}
	t.is_chaining = r.bool()!
	count := int(r.read_varuint32()!)
	t.parameter_data = []ParameterDataEntry{cap: count}
	for _ in 0 .. count {
		t.parameter_data << ParameterDataEntry.decode(mut r)!
	}
	return t
}

pub struct CommandsEntry {
pub mut:
	name                        string
	description                 string
	flags                       u16
	permission_level            enums.CommandPermissionLevel
	alias_enum                  i32
	chained_sub_command_indices []u16
	overloads                   []OverloadsEntry
}

pub fn (t CommandsEntry) encode(mut w serializer.Writer) {
	w.write_string(t.name)
	w.write_string(t.description)
	w.le_u16(t.flags)
	t.permission_level.encode(mut w)
	w.le_i32(t.alias_enum)
	w.write_varuint32(u32(t.chained_sub_command_indices.len))
	for i in t.chained_sub_command_indices {
		w.le_u16(i)
	}
	w.write_varuint32(u32(t.overloads.len))
	for e in t.overloads {
		e.encode(mut w)
	}
}

pub fn CommandsEntry.decode(mut r serializer.Reader) !CommandsEntry {
	mut t := CommandsEntry{}
	t.name = r.read_string()!
	t.description = r.read_string()!
	t.flags = r.le_u16()!
	t.permission_level = enums.CommandPermissionLevel.decode(mut r)!
	t.alias_enum = r.le_i32()!
	idx_count := int(r.read_varuint32()!)
	t.chained_sub_command_indices = []u16{cap: idx_count}
	for _ in 0 .. idx_count {
		t.chained_sub_command_indices << r.le_u16()!
	}
	ov_count := int(r.read_varuint32()!)
	t.overloads = []OverloadsEntry{cap: ov_count}
	for _ in 0 .. ov_count {
		t.overloads << OverloadsEntry.decode(mut r)!
	}
	return t
}

pub struct SoftEnumsEntry {
pub mut:
	enum_name    string
	enum_options []string
}

pub fn (t SoftEnumsEntry) encode(mut w serializer.Writer) {
	w.write_string(t.enum_name)
	w.write_varuint32(u32(t.enum_options.len))
	for s in t.enum_options {
		w.write_string(s)
	}
}

pub fn SoftEnumsEntry.decode(mut r serializer.Reader) !SoftEnumsEntry {
	mut t := SoftEnumsEntry{}
	t.enum_name = r.read_string()!
	count := int(r.read_varuint32()!)
	t.enum_options = []string{cap: count}
	for _ in 0 .. count {
		t.enum_options << r.read_string()!
	}
	return t
}

pub struct ConstraintsEntry {
pub mut:
	enum_value_symbol  u32
	enum_symbol        u32
	constraint_indices []i8
}

pub fn (t ConstraintsEntry) encode(mut w serializer.Writer) {
	w.le_u32(t.enum_value_symbol)
	w.le_u32(t.enum_symbol)
	w.write_varuint32(u32(t.constraint_indices.len))
	for i in t.constraint_indices {
		w.i8(i)
	}
}

pub fn ConstraintsEntry.decode(mut r serializer.Reader) !ConstraintsEntry {
	mut t := ConstraintsEntry{}
	t.enum_value_symbol = r.le_u32()!
	t.enum_symbol = r.le_u32()!
	count := int(r.read_varuint32()!)
	t.constraint_indices = []i8{cap: count}
	for _ in 0 .. count {
		t.constraint_indices << r.i8()!
	}
	return t
}

pub struct ChainedSubCommandDataEntry {
pub mut:
	sub_command_name   string
	sub_command_values []SubCommandValues
}

pub fn (t ChainedSubCommandDataEntry) encode(mut w serializer.Writer) {
	w.write_string(t.sub_command_name)
	w.write_varuint32(u32(t.sub_command_values.len))
	for e in t.sub_command_values {
		e.encode(mut w)
	}
}

pub fn ChainedSubCommandDataEntry.decode(mut r serializer.Reader) !ChainedSubCommandDataEntry {
	mut t := ChainedSubCommandDataEntry{}
	t.sub_command_name = r.read_string()!
	count := int(r.read_varuint32()!)
	t.sub_command_values = []SubCommandValues{cap: count}
	for _ in 0 .. count {
		t.sub_command_values << SubCommandValues.decode(mut r)!
	}
	return t
}

pub struct AvailableCommandsPacket {
pub mut:
	enum_values              []string
	sub_command_values       []string
	post_fixes               []string
	enum_data                []EnumDataEntry
	chained_sub_command_data []ChainedSubCommandDataEntry
	commands                 []CommandsEntry
	soft_enums               []SoftEnumsEntry
	constraints              []ConstraintsEntry
}

pub fn (p &AvailableCommandsPacket) pid() u16 { return 76 }

pub fn (p &AvailableCommandsPacket) name() string { return 'AvailableCommandsPacket' }

pub fn (p &AvailableCommandsPacket) can_be_sent_before_login() bool { return false }

fn write_string_list(mut w serializer.Writer, list []string) {
	w.write_varuint32(u32(list.len))
	for s in list {
		w.write_string(s)
	}
}

fn read_string_list(mut r serializer.Reader) ![]string {
	count := int(r.read_varuint32()!)
	mut list := []string{cap: count}
	for _ in 0 .. count {
		list << r.read_string()!
	}
	return list
}

pub fn (p &AvailableCommandsPacket) encode_payload(mut w serializer.Writer) {
	write_string_list(mut w, p.enum_values)
	write_string_list(mut w, p.sub_command_values)
	write_string_list(mut w, p.post_fixes)
	w.write_varuint32(u32(p.enum_data.len))
	for e in p.enum_data {
		w.write_string(e.name)
		w.write_varuint32(u32(e.values.len))
		for v in e.values {
			if p.enum_values.len <= 255 {
				w.u8(u8(v))
			} else if p.enum_values.len <= 65535 {
				w.le_u16(u16(v))
			} else {
				w.le_u32(v)
			}
		}
	}
	w.write_varuint32(u32(p.chained_sub_command_data.len))
	for e in p.chained_sub_command_data {
		e.encode(mut w)
	}
	w.write_varuint32(u32(p.commands.len))
	for e in p.commands {
		e.encode(mut w)
	}
	w.write_varuint32(u32(p.soft_enums.len))
	for e in p.soft_enums {
		e.encode(mut w)
	}
	w.write_varuint32(u32(p.constraints.len))
	for e in p.constraints {
		e.encode(mut w)
	}
}

pub fn (mut p AvailableCommandsPacket) decode_payload(mut r serializer.Reader) ! {
	p.enum_values = read_string_list(mut r)!
	p.sub_command_values = read_string_list(mut r)!
	p.post_fixes = read_string_list(mut r)!
	{
		count := int(r.read_varuint32()!)
		p.enum_data = []EnumDataEntry{cap: count}
		for _ in 0 .. count {
			name := r.read_string()!
			v_count := int(r.read_varuint32()!)
			mut values := []u32{cap: v_count}
			for _ in 0 .. v_count {
				if p.enum_values.len <= 255 {
					values << u32(r.u8()!)
				} else if p.enum_values.len <= 65535 {
					values << u32(r.le_u16()!)
				} else {
					values << r.le_u32()!
				}
			}
			p.enum_data << EnumDataEntry{
				name:   name
				values: values
			}
		}
	}
	{
		count := int(r.read_varuint32()!)
		p.chained_sub_command_data = []ChainedSubCommandDataEntry{cap: count}
		for _ in 0 .. count {
			p.chained_sub_command_data << ChainedSubCommandDataEntry.decode(mut r)!
		}
	}
	{
		count := int(r.read_varuint32()!)
		p.commands = []CommandsEntry{cap: count}
		for _ in 0 .. count {
			p.commands << CommandsEntry.decode(mut r)!
		}
	}
	{
		count := int(r.read_varuint32()!)
		p.soft_enums = []SoftEnumsEntry{cap: count}
		for _ in 0 .. count {
			p.soft_enums << SoftEnumsEntry.decode(mut r)!
		}
	}
	{
		count := int(r.read_varuint32()!)
		p.constraints = []ConstraintsEntry{cap: count}
		for _ in 0 .. count {
			p.constraints << ConstraintsEntry.decode(mut r)!
		}
	}
}
