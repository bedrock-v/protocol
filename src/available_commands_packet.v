module src

import src.serializer

pub struct CommandEnumData {
pub mut:
	name          string
	value_indices []u32
}

pub struct CommandParameter {
pub mut:
	name      string
	type_info u32
	optional  bool
	flags     u8
}

pub struct CommandOverload {
pub mut:
	chaining   bool
	parameters []CommandParameter
}

pub struct CommandData {
pub mut:
	name                      string
	description               string
	flags                     u16
	permission                string
	alias_enum_index          int
	chained_subcommand_offsets []u32
	overloads                 []CommandOverload
}

pub struct ChainedSubcommandValue {
pub mut:
	name_index u32
	type_info  u32
}

pub struct ChainedSubcommandData {
pub mut:
	name   string
	values []ChainedSubcommandValue
}

pub struct CommandSoftEnum {
pub mut:
	name   string
	values []string
}

pub struct CommandEnumConstraint {
pub mut:
	affected_value_index u32
	enum_index           u32
	constraints          []u8
}

pub struct AvailableCommandsPacket {
pub mut:
	enum_values             []string
	chained_subcommand_values []string
	suffixes                []string
	enums                   []CommandEnumData
	chained_subcommands     []ChainedSubcommandData
	commands                []CommandData
	soft_enums              []CommandSoftEnum
	constraints             []CommandEnumConstraint
}

pub fn (p &AvailableCommandsPacket) pid() u16 {
	return available_commands_packet
}

pub fn (p &AvailableCommandsPacket) name() string {
	return 'AvailableCommandsPacket'
}

pub fn (p &AvailableCommandsPacket) can_be_sent_before_login() bool {
	return false
}

fn read_command_string_list(mut r serializer.Reader) ![]string {
	count := r.read_varuint32()!
	mut out := []string{}
	for _ in 0 .. count {
		out << r.read_string()!
	}
	return out
}

fn write_command_string_list(mut w serializer.Writer, list []string) {
	w.write_varuint32(u32(list.len))
	for s in list {
		w.write_string(s)
	}
}

pub fn (mut p AvailableCommandsPacket) decode_payload(mut r serializer.Reader) ! {
	p.enum_values = read_command_string_list(mut r)!
	p.chained_subcommand_values = read_command_string_list(mut r)!
	p.suffixes = read_command_string_list(mut r)!

	enum_count := r.read_varuint32()!
	p.enums = []CommandEnumData{}
	for _ in 0 .. enum_count {
		mut e := CommandEnumData{
			name: r.read_string()!
		}
		idx_count := r.read_varuint32()!
		e.value_indices = []u32{}
		for _ in 0 .. idx_count {
			e.value_indices << r.le_u32()!
		}
		p.enums << e
	}

	chained_count := r.read_varuint32()!
	p.chained_subcommands = []ChainedSubcommandData{}
	for _ in 0 .. chained_count {
		mut c := ChainedSubcommandData{
			name: r.read_string()!
		}
		val_count := r.read_varuint32()!
		c.values = []ChainedSubcommandValue{}
		for _ in 0 .. val_count {
			c.values << ChainedSubcommandValue{
				name_index: r.read_varuint32()!
				type_info:  r.read_varuint32()!
			}
		}
		p.chained_subcommands << c
	}

	command_count := r.read_varuint32()!
	p.commands = []CommandData{}
	for _ in 0 .. command_count {
		mut cmd := CommandData{
			name:        r.read_string()!
			description: r.read_string()!
			flags:       r.le_u16()!
			permission:  r.read_string()!
		}
		cmd.alias_enum_index = r.le_i32()!
		off_count := r.read_varuint32()!
		cmd.chained_subcommand_offsets = []u32{}
		for _ in 0 .. off_count {
			cmd.chained_subcommand_offsets << r.le_u32()!
		}
		overload_count := r.read_varuint32()!
		cmd.overloads = []CommandOverload{}
		for _ in 0 .. overload_count {
			mut ov := CommandOverload{
				chaining: r.bool()!
			}
			param_count := r.read_varuint32()!
			ov.parameters = []CommandParameter{}
			for _ in 0 .. param_count {
				ov.parameters << CommandParameter{
					name:      r.read_string()!
					type_info: r.le_u32()!
					optional:  r.bool()!
					flags:     r.u8()!
				}
			}
			cmd.overloads << ov
		}
		p.commands << cmd
	}

	soft_count := r.read_varuint32()!
	p.soft_enums = []CommandSoftEnum{}
	for _ in 0 .. soft_count {
		p.soft_enums << CommandSoftEnum{
			name:   r.read_string()!
			values: read_command_string_list(mut r)!
		}
	}

	constraint_count := r.read_varuint32()!
	p.constraints = []CommandEnumConstraint{}
	for _ in 0 .. constraint_count {
		mut con := CommandEnumConstraint{
			affected_value_index: r.le_u32()!
			enum_index:           r.le_u32()!
		}
		byte_count := r.read_varuint32()!
		con.constraints = []u8{}
		for _ in 0 .. byte_count {
			con.constraints << r.u8()!
		}
		p.constraints << con
	}
}

pub fn (p &AvailableCommandsPacket) encode_payload(mut w serializer.Writer) {
	write_command_string_list(mut w, p.enum_values)
	write_command_string_list(mut w, p.chained_subcommand_values)
	write_command_string_list(mut w, p.suffixes)

	w.write_varuint32(u32(p.enums.len))
	for e in p.enums {
		w.write_string(e.name)
		w.write_varuint32(u32(e.value_indices.len))
		for idx in e.value_indices {
			w.le_u32(idx)
		}
	}

	w.write_varuint32(u32(p.chained_subcommands.len))
	for c in p.chained_subcommands {
		w.write_string(c.name)
		w.write_varuint32(u32(c.values.len))
		for v in c.values {
			w.write_varuint32(v.name_index)
			w.write_varuint32(v.type_info)
		}
	}

	w.write_varuint32(u32(p.commands.len))
	for cmd in p.commands {
		w.write_string(cmd.name)
		w.write_string(cmd.description)
		w.le_u16(cmd.flags)
		w.write_string(cmd.permission)
		w.le_i32(cmd.alias_enum_index)
		w.write_varuint32(u32(cmd.chained_subcommand_offsets.len))
		for off in cmd.chained_subcommand_offsets {
			w.le_u32(off)
		}
		w.write_varuint32(u32(cmd.overloads.len))
		for ov in cmd.overloads {
			w.bool(ov.chaining)
			w.write_varuint32(u32(ov.parameters.len))
			for param in ov.parameters {
				w.write_string(param.name)
				w.le_u32(param.type_info)
				w.bool(param.optional)
				w.u8(param.flags)
			}
		}
	}

	w.write_varuint32(u32(p.soft_enums.len))
	for se in p.soft_enums {
		w.write_string(se.name)
		write_command_string_list(mut w, se.values)
	}

	w.write_varuint32(u32(p.constraints.len))
	for con in p.constraints {
		w.le_u32(con.affected_value_index)
		w.le_u32(con.enum_index)
		w.write_varuint32(u32(con.constraints.len))
		for b in con.constraints {
			w.u8(b)
		}
	}
}
