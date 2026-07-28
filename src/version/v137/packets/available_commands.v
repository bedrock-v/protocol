module packets

import protocol.serializer

pub struct CommandEnum {
pub mut:
	name          string
	value_indices []u32
}

pub struct CommandParameter {
pub mut:
	param_name string
	param_type i32
	optional   bool
}

pub struct CommandOverload {
pub mut:
	parameters []CommandParameter
}

pub struct CommandData {
pub mut:
	name             string
	description      string
	flags            u8
	permission       u8
	alias_enum_index i32
	overloads        []CommandOverload
}

pub struct AvailableCommandsPacket {
pub mut:
	enum_values  []string
	postfixes    []string
	enums        []CommandEnum
	command_data []CommandData
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

fn write_enum_value_index(mut w serializer.Writer, index u32, enum_values_count int) {
	if enum_values_count < 256 {
		w.u8(u8(index))
	} else if enum_values_count < 65536 {
		w.le_u16(u16(index))
	} else {
		w.le_i32(i32(index))
	}
}

fn read_enum_value_index(mut r serializer.Reader, enum_values_count int) !u32 {
	if enum_values_count < 256 {
		return u32(r.u8()!)
	} else if enum_values_count < 65536 {
		return u32(r.le_u16()!)
	} else {
		return u32(r.le_i32()!)
	}
}

pub fn (p &AvailableCommandsPacket) encode_payload(mut w serializer.Writer) {
	enum_values_count := p.enum_values.len
	w.write_varuint32(u32(p.enum_values.len))
	for v in p.enum_values {
		w.write_string(v)
	}
	w.write_varuint32(u32(p.postfixes.len))
	for v in p.postfixes {
		w.write_string(v)
	}
	w.write_varuint32(u32(p.enums.len))
	for e in p.enums {
		w.write_string(e.name)
		w.write_varuint32(u32(e.value_indices.len))
		for index in e.value_indices {
			write_enum_value_index(mut w, index, enum_values_count)
		}
	}
	w.write_varuint32(u32(p.command_data.len))
	for cmd in p.command_data {
		w.write_string(cmd.name)
		w.write_string(cmd.description)
		w.u8(cmd.flags)
		w.u8(cmd.permission)
		w.le_i32(cmd.alias_enum_index)
		w.write_varuint32(u32(cmd.overloads.len))
		for overload in cmd.overloads {
			w.write_varuint32(u32(overload.parameters.len))
			for param in overload.parameters {
				w.write_string(param.param_name)
				w.le_i32(param.param_type)
				w.bool(param.optional)
			}
		}
	}
}

pub fn (mut p AvailableCommandsPacket) decode_payload(mut r serializer.Reader) ! {
	enum_values_len := int(r.read_varuint32()!)
	p.enum_values = []string{cap: enum_values_len}
	for _ in 0 .. enum_values_len {
		p.enum_values << r.read_string()!
	}
	enum_values_count := p.enum_values.len

	postfix_len := int(r.read_varuint32()!)
	p.postfixes = []string{cap: postfix_len}
	for _ in 0 .. postfix_len {
		p.postfixes << r.read_string()!
	}

	enum_len := int(r.read_varuint32()!)
	p.enums = []CommandEnum{cap: enum_len}
	for _ in 0 .. enum_len {
		mut e := CommandEnum{}
		e.name = r.read_string()!
		value_count := int(r.read_varuint32()!)
		e.value_indices = []u32{cap: value_count}
		for _ in 0 .. value_count {
			e.value_indices << read_enum_value_index(mut r, enum_values_count)!
		}
		p.enums << e
	}

	command_len := int(r.read_varuint32()!)
	p.command_data = []CommandData{cap: command_len}
	for _ in 0 .. command_len {
		mut cmd := CommandData{}
		cmd.name = r.read_string()!
		cmd.description = r.read_string()!
		cmd.flags = r.u8()!
		cmd.permission = r.u8()!
		cmd.alias_enum_index = r.le_i32()!
		overload_count := int(r.read_varuint32()!)
		cmd.overloads = []CommandOverload{cap: overload_count}
		for _ in 0 .. overload_count {
			mut overload := CommandOverload{}
			param_count := int(r.read_varuint32()!)
			overload.parameters = []CommandParameter{cap: param_count}
			for _ in 0 .. param_count {
				mut param := CommandParameter{}
				param.param_name = r.read_string()!
				param.param_type = r.le_i32()!
				param.optional = r.bool()!
				overload.parameters << param
			}
			cmd.overloads << overload
		}
		p.command_data << cmd
	}
}
