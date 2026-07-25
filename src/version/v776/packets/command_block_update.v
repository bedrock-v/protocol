module packets

import serializer
import version.v662.types
import version.v662.enums

pub struct CommandBlockUpdatePacket {
pub mut:
	is_block                     bool
	target_runtime_id            types.ActorRuntimeID
	block_position               types.NetworkBlockPosition
	command_block_mode           enums.CommandBlockMode
	redstone_mode                bool
	is_conditional               bool
	command                      string
	last_output                  string
	name                         string
	filtered_name                string
	track_output                 bool
	tick_delay                   u32
	should_execute_on_first_tick bool
}

pub fn (p &CommandBlockUpdatePacket) pid() u16 { return 78 }

pub fn (p &CommandBlockUpdatePacket) name() string { return 'CommandBlockUpdatePacket' }

pub fn (p &CommandBlockUpdatePacket) can_be_sent_before_login() bool { return false }

pub fn (p &CommandBlockUpdatePacket) encode_payload(mut w serializer.Writer) {
	w.bool(p.is_block)
	if p.is_block {
		p.block_position.encode(mut w)
		p.command_block_mode.encode(mut w)
		w.bool(p.redstone_mode)
		w.bool(p.is_conditional)
	} else {
		p.target_runtime_id.encode(mut w)
	}
	w.write_string(p.command)
	w.write_string(p.last_output)
	w.write_string(p.name)
	w.write_string(p.filtered_name)
	w.bool(p.track_output)
	w.le_u32(p.tick_delay)
	w.bool(p.should_execute_on_first_tick)
}

pub fn (mut p CommandBlockUpdatePacket) decode_payload(mut r serializer.Reader) ! {
	p.is_block = r.bool()!
	if p.is_block {
		p.block_position = types.NetworkBlockPosition.decode(mut r)!
		p.command_block_mode = enums.CommandBlockMode.decode(mut r)!
		p.redstone_mode = r.bool()!
		p.is_conditional = r.bool()!
	} else {
		p.target_runtime_id = types.ActorRuntimeID.decode(mut r)!
	}
	p.command = r.read_string()!
	p.last_output = r.read_string()!
	p.name = r.read_string()!
	p.filtered_name = r.read_string()!
	p.track_output = r.bool()!
	p.tick_delay = r.le_u32()!
	p.should_execute_on_first_tick = r.bool()!
}
