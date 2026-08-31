module packets

import protocol.serializer
import protocol.version.v137.types

pub struct BlockEventPacket {
pub mut:
	position types.BlockPosition
	case1    i32
	case2    i32
}

pub fn (p &BlockEventPacket) pid() u16 {
	return 26
}

pub fn (p &BlockEventPacket) name() string {
	return 'BlockEventPacket'
}

pub fn (p &BlockEventPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &BlockEventPacket) encode_payload(mut w serializer.Writer) {
	p.position.encode(mut w)
	w.write_varint32(p.case1)
	w.write_varint32(p.case2)
}

pub fn (mut p BlockEventPacket) decode_payload(mut r serializer.Reader) ! {
	p.position = types.BlockPosition.decode(mut r)!
	p.case1 = r.read_varint32()!
	p.case2 = r.read_varint32()!
}
