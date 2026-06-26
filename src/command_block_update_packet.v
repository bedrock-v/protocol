module src

import src.serializer
import src.types

pub struct CommandBlockUpdatePacket {
pub mut:
	is_block                   bool
	block_position             types.BlockPosition
	command_block_mode         int
	is_redstone_mode           bool
	is_conditional             bool
	minecart_actor_runtime_id  u64
	command                    string
	last_output                string
	name                       string
	filtered_name              string
	should_track_output        bool
	tick_delay                 int
	execute_on_first_tick      bool
}

pub fn (p &CommandBlockUpdatePacket) pid() u16 {
	return command_block_update_packet
}

pub fn (p &CommandBlockUpdatePacket) name() string {
	return 'CommandBlockUpdatePacket'
}

pub fn (p &CommandBlockUpdatePacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p CommandBlockUpdatePacket) decode_payload(mut r serializer.Reader) ! {
	p.is_block = r.bool()!
	if p.is_block {
		p.block_position = r.read_block_position()!
		p.command_block_mode = int(r.read_varuint32()!)
		p.is_redstone_mode = r.bool()!
		p.is_conditional = r.bool()!
	} else {
		p.minecart_actor_runtime_id = r.read_actor_runtime_id()!
	}
	p.command = r.read_string()!
	p.last_output = r.read_string()!
	p.name = r.read_string()!
	p.filtered_name = r.read_string()!
	p.should_track_output = r.bool()!
	p.tick_delay = int(r.le_u32()!)
	p.execute_on_first_tick = r.bool()!
}

pub fn (p &CommandBlockUpdatePacket) encode_payload(mut w serializer.Writer) {
	w.bool(p.is_block)
	if p.is_block {
		w.write_block_position(p.block_position)
		w.write_varuint32(u32(p.command_block_mode))
		w.bool(p.is_redstone_mode)
		w.bool(p.is_conditional)
	} else {
		w.write_actor_runtime_id(p.minecart_actor_runtime_id)
	}
	w.write_string(p.command)
	w.write_string(p.last_output)
	w.write_string(p.name)
	w.write_string(p.filtered_name)
	w.bool(p.should_track_output)
	w.le_u32(u32(p.tick_delay))
	w.bool(p.execute_on_first_tick)
}
