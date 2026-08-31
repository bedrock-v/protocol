module packets

import protocol.serializer

pub struct BlockEventPacket {
pub mut:
	x     i32
	y     u32
	z     i32
	case1 i32
	case2 i32
}

pub fn (p &BlockEventPacket) pid() u16 {
	return 0x1b
}

pub fn (p &BlockEventPacket) name() string {
	return 'BlockEventPacket'
}

pub fn (p &BlockEventPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &BlockEventPacket) encode_payload(mut w serializer.Writer) {
	w.write_varint32(p.x)
	w.write_varuint32(p.y)
	w.write_varint32(p.z)
	w.write_varint32(p.case1)
	w.write_varint32(p.case2)
}

pub fn (mut p BlockEventPacket) decode_payload(mut r serializer.Reader) ! {
	p.x = r.read_varint32()!
	p.y = r.read_varuint32()!
	p.z = r.read_varint32()!
	p.case1 = r.read_varint32()!
	p.case2 = r.read_varint32()!
}
