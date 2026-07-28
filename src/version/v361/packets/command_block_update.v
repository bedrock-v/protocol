module packets

import protocol.serializer
import protocol.version.v291.types

pub struct CommandBlockUpdatePacket {
pub mut:
	block                      bool
	block_position             types.BlockPosition
	mode                       u32
	redstone_mode              bool
	conditional                bool
	minecart_runtime_entity_id u64
	command                    string
	last_output                string
	name                       string
	output_tracked             bool
	tick_delay                 u32
	executing_on_first_tick    bool
}

pub fn (p &CommandBlockUpdatePacket) pid() u16 {
	return 78
}

pub fn (p &CommandBlockUpdatePacket) name() string {
	return 'CommandBlockUpdatePacket'
}

pub fn (p &CommandBlockUpdatePacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &CommandBlockUpdatePacket) encode_payload(mut w serializer.Writer) {
	w.bool(p.block)
	if p.block {
		p.block_position.encode(mut w)
		w.write_varuint32(p.mode)
		w.bool(p.redstone_mode)
		w.bool(p.conditional)
	} else {
		w.write_varuint64(p.minecart_runtime_entity_id)
	}
	w.write_string(p.command)
	w.write_string(p.last_output)
	w.write_string(p.name)
	w.bool(p.output_tracked)
	w.le_u32(p.tick_delay)
	w.bool(p.executing_on_first_tick)
}

pub fn (mut p CommandBlockUpdatePacket) decode_payload(mut r serializer.Reader) ! {
	p.block = r.bool()!
	if p.block {
		p.block_position = types.BlockPosition.decode(mut r)!
		p.mode = r.read_varuint32()!
		p.redstone_mode = r.bool()!
		p.conditional = r.bool()!
	} else {
		p.minecart_runtime_entity_id = r.read_varuint64()!
	}
	p.command = r.read_string()!
	p.last_output = r.read_string()!
	p.name = r.read_string()!
	p.output_tracked = r.bool()!
	p.tick_delay = r.le_u32()!
	p.executing_on_first_tick = r.bool()!
}
