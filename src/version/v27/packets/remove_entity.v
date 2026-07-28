module packets

import protocol.serializer

pub struct RemoveEntityPacket {
pub mut:
	eid i64
}

pub fn (p &RemoveEntityPacket) pid() u16 {
	return 0x8b
}

pub fn (p &RemoveEntityPacket) name() string {
	return 'RemoveEntityPacket'
}

pub fn (p &RemoveEntityPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &RemoveEntityPacket) encode_payload(mut w serializer.Writer) {
	w.be_i64(p.eid)
}

pub fn (mut p RemoveEntityPacket) decode_payload(mut r serializer.Reader) ! {
	p.eid = r.be_i64()!
}
