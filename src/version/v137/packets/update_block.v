module packets

import protocol.serializer
import protocol.version.v137.types

pub struct UpdateBlockPacket {
pub mut:
	position   types.BlockPosition
	block_id   u32
	block_data u32
	flags      u32
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
	w.write_varuint32(p.block_id)
	w.write_varuint32((p.flags << 4) | p.block_data)
}

pub fn (mut p UpdateBlockPacket) decode_payload(mut r serializer.Reader) ! {
	p.position = types.BlockPosition.decode(mut r)!
	p.block_id = r.read_varuint32()!
	aux := r.read_varuint32()!
	p.block_data = aux & 0x0f
	p.flags = aux >> 4
}
