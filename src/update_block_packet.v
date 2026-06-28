module protocol

import serializer
import types

pub struct UpdateBlockPacket {
pub mut:
	block_position  types.BlockPosition
	block_runtime_id int
	flags           int
	data_layer_id   int
}

pub fn (p &UpdateBlockPacket) pid() u16 {
	return update_block_packet
}

pub fn (p &UpdateBlockPacket) name() string {
	return 'UpdateBlockPacket'
}

pub fn (p &UpdateBlockPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p UpdateBlockPacket) decode_payload(mut r serializer.Reader) ! {
	p.block_position = r.read_block_position()!
	p.block_runtime_id = int(r.read_varuint32()!)
	p.flags = int(r.read_varuint32()!)
	p.data_layer_id = int(r.read_varuint32()!)
}

pub fn (p &UpdateBlockPacket) encode_payload(mut w serializer.Writer) {
	w.write_block_position(p.block_position)
	w.write_varuint32(u32(p.block_runtime_id))
	w.write_varuint32(u32(p.flags))
	w.write_varuint32(u32(p.data_layer_id))
}
