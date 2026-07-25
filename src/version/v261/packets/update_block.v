module packets

import serializer
import version.v137.types

pub struct UpdateBlockPacket {
pub mut:
	position         types.BlockPosition
	block_runtime_id u32
	flags            u32
	data_layer_id    u32
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
	p.position.encode(mut w)
	w.write_varuint32(p.block_runtime_id)
	w.write_varuint32(p.flags)
	w.write_varuint32(p.data_layer_id)
}

pub fn (mut p UpdateBlockPacket) decode_payload(mut r serializer.Reader) ! {
	p.position = types.BlockPosition.decode(mut r)!
	p.block_runtime_id = r.read_varuint32()!
	p.flags = r.read_varuint32()!
	p.data_layer_id = r.read_varuint32()!
}
