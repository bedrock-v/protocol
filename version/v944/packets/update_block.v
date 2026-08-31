module packets

import protocol.serializer
import protocol.version.v944.types

pub struct UpdateBlockPacket {
pub mut:
	block_position   types.NetworkBlockPosition
	block_runtime_id u32
	flags            u32
	layer            u32
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
	w.write_varuint32(p.block_runtime_id)
	w.write_varuint32(p.flags)
	w.write_varuint32(p.layer)
}

pub fn (mut p UpdateBlockPacket) decode_payload(mut r serializer.Reader) ! {
	p.block_position = types.NetworkBlockPosition.decode(mut r)!
	p.block_runtime_id = r.read_varuint32()!
	p.flags = r.read_varuint32()!
	p.layer = r.read_varuint32()!
}
