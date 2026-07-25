module packets

import serializer
import version.v662.types

pub struct BlockPickRequestPacket {
pub mut:
	position  types.BlockPos
	with_data bool
	max_slots i8
}

pub fn (p &BlockPickRequestPacket) pid() u16 { return 34 }

pub fn (p &BlockPickRequestPacket) name() string { return 'BlockPickRequestPacket' }

pub fn (p &BlockPickRequestPacket) can_be_sent_before_login() bool { return false }

pub fn (p &BlockPickRequestPacket) encode_payload(mut w serializer.Writer) {
	p.position.encode(mut w)
	w.bool(p.with_data)
	w.i8(p.max_slots)
}

pub fn (mut p BlockPickRequestPacket) decode_payload(mut r serializer.Reader) ! {
	p.position = types.BlockPos.decode(mut r)!
	p.with_data = r.bool()!
	p.max_slots = r.i8()!
}
