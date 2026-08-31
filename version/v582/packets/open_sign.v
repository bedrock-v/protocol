module packets

import protocol.serializer
import protocol.version.v291.types as types_291

pub struct OpenSignPacket {
pub mut:
	position   types_291.BlockPosition
	front_side bool
}

pub fn (p &OpenSignPacket) pid() u16 {
	return 303
}

pub fn (p &OpenSignPacket) name() string {
	return 'OpenSignPacket'
}

pub fn (p &OpenSignPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &OpenSignPacket) encode_payload(mut w serializer.Writer) {
	p.position.encode(mut w)
	w.bool(p.front_side)
}

pub fn (mut p OpenSignPacket) decode_payload(mut r serializer.Reader) ! {
	p.position = types_291.BlockPosition.decode(mut r)!
	p.front_side = r.bool()!
}
