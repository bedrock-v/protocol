module packets

import protocol.serializer

pub struct RemoveBlockPacket {
pub mut:
	x i32
	y u8
	z i32
}

pub fn (p &RemoveBlockPacket) pid() u16 {
	return 0x16
}

pub fn (p &RemoveBlockPacket) name() string {
	return 'RemoveBlockPacket'
}

pub fn (p &RemoveBlockPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &RemoveBlockPacket) encode_payload(mut w serializer.Writer) {
	w.write_varint32(p.x)
	w.u8(p.y)
	w.write_varint32(p.z)
}

pub fn (mut p RemoveBlockPacket) decode_payload(mut r serializer.Reader) ! {
	p.x = r.read_varint32()!
	p.y = r.u8()!
	p.z = r.read_varint32()!
}
