module packets

import protocol.serializer
import protocol.version.v662.types

pub struct OpenSignPacket {
pub mut:
	pos      types.NetworkBlockPosition
	is_front bool
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
	p.pos.encode(mut w)
	w.bool(p.is_front)
}

pub fn (mut p OpenSignPacket) decode_payload(mut r serializer.Reader) ! {
	p.pos = types.NetworkBlockPosition.decode(mut r)!
	p.is_front = r.bool()!
}
