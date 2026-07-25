module packets

import serializer
import version.v291.types

pub const update_block_flag_neighbors = u32(1 << 0)
pub const update_block_flag_network = u32(1 << 1)
pub const update_block_flag_no_graphic = u32(1 << 2)
pub const update_block_flag_unused = u32(1 << 3)
pub const update_block_flag_priority = u32(1 << 4)

pub struct UpdateBlockPacket {
pub mut:
	block_position types.BlockPosition
	definition     u32
	flags          u32
	data_layer     u32
}

pub fn (p &UpdateBlockPacket) pid() u16 {
	return 21
}

pub fn (p &UpdateBlockPacket) name() string {
	return 'UpdateBlockPacket'
}

pub fn (p &UpdateBlockPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &UpdateBlockPacket) encode_payload(mut w serializer.Writer) {
	p.block_position.encode(mut w)
	w.write_varuint32(p.definition)
	w.write_varuint32(p.flags)
	w.write_varuint32(p.data_layer)
}

pub fn (mut p UpdateBlockPacket) decode_payload(mut r serializer.Reader) ! {
	p.block_position = types.BlockPosition.decode(mut r)!
	p.definition = r.read_varuint32()!
	p.flags = r.read_varuint32()!
	p.data_layer = r.read_varuint32()!
}
