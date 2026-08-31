module packets

import protocol.serializer

pub struct UpdateBlockPacket {
pub mut:
	x          i32
	y          u8
	z          i32
	block_id   u32
	block_data u32
	flags      u32
}

pub fn (p &UpdateBlockPacket) pid() u16 {
	return 0x17
}

pub fn (p &UpdateBlockPacket) name() string {
	return 'UpdateBlockPacket'
}

pub fn (p &UpdateBlockPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &UpdateBlockPacket) encode_payload(mut w serializer.Writer) {
	w.write_varint32(p.x)
	w.u8(p.y)
	w.write_varint32(p.z)
	w.write_varuint32(p.block_id)
	w.write_varuint32((p.flags << 4) | (p.block_data & 0x0f))
}

pub fn (mut p UpdateBlockPacket) decode_payload(mut r serializer.Reader) ! {
	p.x = r.read_varint32()!
	p.y = r.u8()!
	p.z = r.read_varint32()!
	p.block_id = r.read_varuint32()!
	c := r.read_varuint32()!
	p.flags = c >> 4
	p.block_data = c & 0x0f
}
