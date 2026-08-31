module packets

import protocol.serializer

pub struct UpdateBlockPacket {
pub mut:
	x          i32
	z          i32
	y          u8
	block_id   u8
	block_data u8
	flags      u8
}

pub fn (p &UpdateBlockPacket) pid() u16 {
	return 0x14
}

pub fn (p &UpdateBlockPacket) name() string {
	return 'UpdateBlockPacket'
}

pub fn (p &UpdateBlockPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &UpdateBlockPacket) encode_payload(mut w serializer.Writer) {
	w.be_i32(p.x)
	w.be_i32(p.z)
	w.u8(p.y)
	w.u8(p.block_id)
	w.u8((p.flags << 4) | (p.block_data & 0x0f))
}

pub fn (mut p UpdateBlockPacket) decode_payload(mut r serializer.Reader) ! {
	p.x = r.be_i32()!
	p.z = r.be_i32()!
	p.y = r.u8()!
	p.block_id = r.u8()!
	b := r.u8()!
	p.flags = b >> 4
	p.block_data = b & 0x0f
}
