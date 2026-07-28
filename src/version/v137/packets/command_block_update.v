module packets

import protocol.serializer
import protocol.version.v137.types

pub struct CommandBlockUpdatePacket {
pub mut:
	is_block            bool
	position            types.BlockPosition
	command_block_mode  u32
	is_redstone_mode    bool
	is_conditional      bool
	minecart_eid        u64
	command             string
	last_output         string
	name                string
	should_track_output bool
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
	w.bool(p.is_block)

	if p.is_block {
		p.position.encode(mut w)
		w.write_varuint32(p.command_block_mode)
		w.bool(p.is_redstone_mode)
		w.bool(p.is_conditional)
	} else {
		w.write_varuint64(p.minecart_eid)
	}

	w.write_string(p.command)
	w.write_string(p.last_output)
	w.write_string(p.name)

	w.bool(p.should_track_output)
}

pub fn (mut p CommandBlockUpdatePacket) decode_payload(mut r serializer.Reader) ! {
	p.is_block = r.bool()!

	if p.is_block {
		p.position = types.BlockPosition.decode(mut r)!
		p.command_block_mode = r.read_varuint32()!
		p.is_redstone_mode = r.bool()!
		p.is_conditional = r.bool()!
	} else {
		p.minecart_eid = r.read_varuint64()!
	}

	p.command = r.read_string()!
	p.last_output = r.read_string()!
	p.name = r.read_string()!

	p.should_track_output = r.bool()!
}
