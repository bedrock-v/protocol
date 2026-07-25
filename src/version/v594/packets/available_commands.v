module packets

import serializer
import version.v291.types as types_291
import version.v388.types as types_388
import version.v594.types

pub struct AvailableCommandsPacket {
pub mut:
	enum_values        []string
	sub_command_values []string
	postfixes          []string
	enums              []types_291.CommandEnumIndexed
	sub_commands       []types.ChainedSubCommandData
	commands           []types.CommandData
	soft_enums         []types_291.CommandEnumData
	constraints        []types_388.CommandEnumConstraintData
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
	w.write_varuint32(u32(p.sub_command_values.len))
	for value in p.sub_command_values {
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
	w.write_varuint32(u32(p.sub_commands.len))
	for sub_command in p.sub_commands {
		sub_command.encode(mut w)
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
	value_count := int(r.read_varuint32()!)
	p.enum_values = []string{cap: value_count}
	for _ in 0 .. value_count {
		p.enum_values << r.read_string()!
	}
	sub_command_value_count := int(r.read_varuint32()!)
	p.sub_command_values = []string{cap: sub_command_value_count}
	for _ in 0 .. sub_command_value_count {
		p.sub_command_values << r.read_string()!
	}
	postfix_count := int(r.read_varuint32()!)
	p.postfixes = []string{cap: postfix_count}
	for _ in 0 .. postfix_count {
		p.postfixes << r.read_string()!
	}
	index_size := types_291.enum_index_size(p.enum_values.len)
	enum_count := int(r.read_varuint32()!)
	p.enums = []types_291.CommandEnumIndexed{cap: enum_count}
	for _ in 0 .. enum_count {
		p.enums << types_291.CommandEnumIndexed.decode(mut r, index_size)!
	}
	sub_command_count := int(r.read_varuint32()!)
	p.sub_commands = []types.ChainedSubCommandData{cap: sub_command_count}
	for _ in 0 .. sub_command_count {
		p.sub_commands << types.ChainedSubCommandData.decode(mut r)!
	}
	command_count := int(r.read_varuint32()!)
	p.commands = []types.CommandData{cap: command_count}
	for _ in 0 .. command_count {
		p.commands << types.CommandData.decode(mut r)!
	}
	soft_enum_count := int(r.read_varuint32()!)
	p.soft_enums = []types_291.CommandEnumData{cap: soft_enum_count}
	for _ in 0 .. soft_enum_count {
		p.soft_enums << types_291.CommandEnumData.decode(mut r, true)!
	}
	constraint_count := int(r.read_varuint32()!)
	p.constraints = []types_388.CommandEnumConstraintData{cap: constraint_count}
	for _ in 0 .. constraint_count {
		p.constraints << types_388.CommandEnumConstraintData.decode(mut r)!
	}
}
