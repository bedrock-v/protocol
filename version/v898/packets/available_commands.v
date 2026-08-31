module packets

import protocol.serializer

pub enum CommandPermissionLevelString as i8 {
	any            = 0
	game_directors = 1
	admin          = 2
	host           = 3
	owner          = 4
	internal       = 5
}

pub fn (e CommandPermissionLevelString) wire_name() string {
	return match e {
		.any { 'any' }
		.game_directors { 'gamedirectors' }
		.admin { 'admin' }
		.host { 'host' }
		.owner { 'owner' }
		.internal { 'internal' }
	}
}

pub fn (e CommandPermissionLevelString) encode(mut w serializer.Writer) {
	w.write_string(e.wire_name())
}

pub fn CommandPermissionLevelString.decode(mut r serializer.Reader) !CommandPermissionLevelString {
	s := r.read_string()!
	match s {
		'any' { return CommandPermissionLevelString.any }
		'gamedirectors' { return CommandPermissionLevelString.game_directors }
		'admin' { return CommandPermissionLevelString.admin }
		'host' { return CommandPermissionLevelString.host }
		'owner' { return CommandPermissionLevelString.owner }
		'internal' { return CommandPermissionLevelString.internal }
		else { return error('invalid CommandPermissionLevelString ${s}') }
	}
}

pub struct EnumDataEntry {
pub mut:
	name   string
	values []u32
}

pub fn (e EnumDataEntry) encode(mut w serializer.Writer) {
	w.write_string(e.name)
	w.write_varuint32(u32(e.values.len))
	for v in e.values {
		w.le_u32(v)
	}
}

pub fn EnumDataEntry.decode(mut r serializer.Reader) !EnumDataEntry {
	mut e := EnumDataEntry{}
	e.name = r.read_string()!
	count := r.read_count()!
	e.values = []u32{cap: serializer.prealloc(count)}
	for _ in 0 .. count {
		e.values << r.le_u32()!
	}
	return e
}

pub struct SubCommandValues {
pub mut:
	index u32
	value u32
}

pub fn (e SubCommandValues) encode(mut w serializer.Writer) {
	w.write_varuint32(e.index)
	w.write_varuint32(e.value)
}

pub fn SubCommandValues.decode(mut r serializer.Reader) !SubCommandValues {
	return SubCommandValues{
		index: r.read_varuint32()!
		value: r.read_varuint32()!
	}
}

pub struct ParameterDataEntry {
pub mut:
	name         string
	parse_symbol u32
	is_optional  bool
	options      i8
}

pub fn (e ParameterDataEntry) encode(mut w serializer.Writer) {
	w.write_string(e.name)
	w.le_u32(e.parse_symbol)
	w.bool(e.is_optional)
	w.i8(e.options)
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

pub fn (e OverloadsEntry) encode(mut w serializer.Writer) {
	w.bool(e.is_chaining)
	w.write_varuint32(u32(e.parameter_data.len))
	for d in e.parameter_data {
		d.encode(mut w)
	}
}

pub fn OverloadsEntry.decode(mut r serializer.Reader) !OverloadsEntry {
	mut e := OverloadsEntry{}
	e.is_chaining = r.bool()!
	count := r.read_count()!
	e.parameter_data = []ParameterDataEntry{cap: serializer.prealloc(count)}
	for _ in 0 .. count {
		e.parameter_data << ParameterDataEntry.decode(mut r)!
	}
	return e
}

pub struct CommandsEntry {
pub mut:
	name                        string
	description                 string
	flags                       u16
	permission_level            CommandPermissionLevelString
	alias_enum                  i32
	chained_sub_command_indices []i32
	overloads                   []OverloadsEntry
}

pub fn (e CommandsEntry) encode(mut w serializer.Writer) {
	w.write_string(e.name)
	w.write_string(e.description)
	w.le_u16(e.flags)
	e.permission_level.encode(mut w)
	w.le_i32(e.alias_enum)
	w.write_varuint32(u32(e.chained_sub_command_indices.len))
	for i in e.chained_sub_command_indices {
		w.le_i32(i)
	}
	w.write_varuint32(u32(e.overloads.len))
	for o in e.overloads {
		o.encode(mut w)
	}
}

pub fn CommandsEntry.decode(mut r serializer.Reader) !CommandsEntry {
	mut e := CommandsEntry{}
	e.name = r.read_string()!
	e.description = r.read_string()!
	e.flags = r.le_u16()!
	e.permission_level = CommandPermissionLevelString.decode(mut r)!
	e.alias_enum = r.le_i32()!
	index_count := r.read_count()!
	e.chained_sub_command_indices = []i32{cap: serializer.prealloc(index_count)}
	for _ in 0 .. index_count {
		e.chained_sub_command_indices << r.le_i32()!
	}
	overload_count := r.read_count()!
	e.overloads = []OverloadsEntry{cap: serializer.prealloc(overload_count)}
	for _ in 0 .. overload_count {
		e.overloads << OverloadsEntry.decode(mut r)!
	}
	return e
}

pub struct SoftEnumsEntry {
pub mut:
	enum_name    string
	enum_options []string
}

pub fn (e SoftEnumsEntry) encode(mut w serializer.Writer) {
	w.write_string(e.enum_name)
	w.write_varuint32(u32(e.enum_options.len))
	for s in e.enum_options {
		w.write_string(s)
	}
}

pub fn SoftEnumsEntry.decode(mut r serializer.Reader) !SoftEnumsEntry {
	mut e := SoftEnumsEntry{}
	e.enum_name = r.read_string()!
	count := r.read_count()!
	e.enum_options = []string{cap: serializer.prealloc(count)}
	for _ in 0 .. count {
		e.enum_options << r.read_string()!
	}
	return e
}

pub struct ConstraintsEntry {
pub mut:
	enum_value_symbol  u32
	enum_symbol        u32
	constraint_indices []i8
}

pub fn (e ConstraintsEntry) encode(mut w serializer.Writer) {
	w.le_u32(e.enum_value_symbol)
	w.le_u32(e.enum_symbol)
	w.write_varuint32(u32(e.constraint_indices.len))
	for i in e.constraint_indices {
		w.i8(i)
	}
}

pub fn ConstraintsEntry.decode(mut r serializer.Reader) !ConstraintsEntry {
	mut e := ConstraintsEntry{}
	e.enum_value_symbol = r.le_u32()!
	e.enum_symbol = r.le_u32()!
	count := r.read_count()!
	e.constraint_indices = []i8{cap: serializer.prealloc(count)}
	for _ in 0 .. count {
		e.constraint_indices << r.i8()!
	}
	return e
}

pub struct ChainedSubCommandDataEntry {
pub mut:
	sub_command_name   string
	sub_command_values []SubCommandValues
}

pub fn (e ChainedSubCommandDataEntry) encode(mut w serializer.Writer) {
	w.write_string(e.sub_command_name)
	w.write_varuint32(u32(e.sub_command_values.len))
	for v in e.sub_command_values {
		v.encode(mut w)
	}
}

pub fn ChainedSubCommandDataEntry.decode(mut r serializer.Reader) !ChainedSubCommandDataEntry {
	mut e := ChainedSubCommandDataEntry{}
	e.sub_command_name = r.read_string()!
	count := r.read_count()!
	e.sub_command_values = []SubCommandValues{cap: serializer.prealloc(count)}
	for _ in 0 .. count {
		e.sub_command_values << SubCommandValues.decode(mut r)!
	}
	return e
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

fn write_string_list(mut w serializer.Writer, list []string) {
	w.write_varuint32(u32(list.len))
	for s in list {
		w.write_string(s)
	}
}

fn read_string_list(mut r serializer.Reader) ![]string {
	count := r.read_count()!
	mut out := []string{cap: serializer.prealloc(count)}
	for _ in 0 .. count {
		out << r.read_string()!
	}
	return out
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
	write_string_list(mut w, p.enum_values)
	write_string_list(mut w, p.sub_command_values)
	write_string_list(mut w, p.post_fixes)
	w.write_varuint32(u32(p.enum_data.len))
	for e in p.enum_data {
		e.encode(mut w)
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
	enum_data_count := r.read_count()!
	p.enum_data = []EnumDataEntry{cap: serializer.prealloc(enum_data_count)}
	for _ in 0 .. enum_data_count {
		p.enum_data << EnumDataEntry.decode(mut r)!
	}
	chained_count := r.read_count()!
	p.chained_sub_command_data = []ChainedSubCommandDataEntry{cap: serializer.prealloc(chained_count)}
	for _ in 0 .. chained_count {
		p.chained_sub_command_data << ChainedSubCommandDataEntry.decode(mut r)!
	}
	command_count := r.read_count()!
	p.commands = []CommandsEntry{cap: serializer.prealloc(command_count)}
	for _ in 0 .. command_count {
		p.commands << CommandsEntry.decode(mut r)!
	}
	soft_enum_count := r.read_count()!
	p.soft_enums = []SoftEnumsEntry{cap: serializer.prealloc(soft_enum_count)}
	for _ in 0 .. soft_enum_count {
		p.soft_enums << SoftEnumsEntry.decode(mut r)!
	}
	constraint_count := r.read_count()!
	p.constraints = []ConstraintsEntry{cap: serializer.prealloc(constraint_count)}
	for _ in 0 .. constraint_count {
		p.constraints << ConstraintsEntry.decode(mut r)!
	}
}
