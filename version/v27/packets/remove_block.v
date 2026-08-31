module packets

import protocol.serializer

pub struct RemoveBlockPacket {
pub mut:
	eid i64
	x   i32
	z   i32
	y   u8
}

pub fn (p &RemoveBlockPacket) pid() u16 {
	return 0x90
}

pub fn (p &RemoveBlockPacket) name() string {
	return 'RemoveBlockPacket'
}

pub fn (p &RemoveBlockPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &RemoveBlockPacket) encode_payload(mut w serializer.Writer) {
	w.be_i64(p.eid)
	w.be_i32(p.x)
	w.be_i32(p.z)
	w.u8(p.y)
}

pub fn (mut p RemoveBlockPacket) decode_payload(mut r serializer.Reader) ! {
	p.eid = r.be_i64()!
	p.x = r.be_i32()!
	p.z = r.be_i32()!
	p.y = r.u8()!
}
