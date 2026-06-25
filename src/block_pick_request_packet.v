module src

import src.serializer
import src.types

pub struct BlockPickRequestPacket {
pub mut:
	block_position types.BlockPosition
	add_user_data  bool
	hotbar_slot    int
}

pub fn (p &BlockPickRequestPacket) pid() u16 {
	return block_pick_request_packet
}

pub fn (p &BlockPickRequestPacket) name() string {
	return 'BlockPickRequestPacket'
}

pub fn (p &BlockPickRequestPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p BlockPickRequestPacket) decode_payload(mut r serializer.Reader) ! {
	p.block_position = r.read_block_position()!
	p.add_user_data = r.bool()!
	p.hotbar_slot = int(r.u8()!)
}

pub fn (p &BlockPickRequestPacket) encode_payload(mut w serializer.Writer) {
	w.write_block_position(p.block_position)
	w.bool(p.add_user_data)
	w.u8(u8(p.hotbar_slot))
}
