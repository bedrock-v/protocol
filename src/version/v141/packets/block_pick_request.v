module packets

import serializer
import version.v137.types

pub struct BlockPickRequestPacket {
pub mut:
	tile          types.Vector3i
	add_user_data bool
	hotbar_slot   u8
}

pub fn (p &BlockPickRequestPacket) pid() u16 {
	return 34
}

pub fn (p &BlockPickRequestPacket) name() string {
	return 'BlockPickRequestPacket'
}

pub fn (p &BlockPickRequestPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &BlockPickRequestPacket) encode_payload(mut w serializer.Writer) {
	p.tile.encode(mut w)
	w.bool(p.add_user_data)
	w.u8(p.hotbar_slot)
}

pub fn (mut p BlockPickRequestPacket) decode_payload(mut r serializer.Reader) ! {
	p.tile = types.Vector3i.decode(mut r)!
	p.add_user_data = r.bool()!
	p.hotbar_slot = r.u8()!
}
