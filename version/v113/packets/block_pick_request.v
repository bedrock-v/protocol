module packets

import protocol.serializer

pub struct BlockPickRequestPacket {
pub mut:
	tile_x      i32
	tile_y      i32
	tile_z      i32
	hotbar_slot u8
}

pub fn (p &BlockPickRequestPacket) pid() u16 {
	return 0x22
}

pub fn (p &BlockPickRequestPacket) name() string {
	return 'BlockPickRequestPacket'
}

pub fn (p &BlockPickRequestPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &BlockPickRequestPacket) encode_payload(mut w serializer.Writer) {
	w.write_varint32(p.tile_x)
	w.write_varint32(p.tile_y)
	w.write_varint32(p.tile_z)
	w.u8(p.hotbar_slot)
}

pub fn (mut p BlockPickRequestPacket) decode_payload(mut r serializer.Reader) ! {
	p.tile_x = r.read_varint32()!
	p.tile_y = r.read_varint32()!
	p.tile_z = r.read_varint32()!
	p.hotbar_slot = r.u8()!
}
