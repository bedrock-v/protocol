module packets

import protocol.serializer

pub struct RemovePlayerPacket {
pub mut:
	eid       i32
	client_id i64
}

pub fn (p &RemovePlayerPacket) pid() u16 {
	return 0x8a
}

pub fn (p &RemovePlayerPacket) name() string {
	return 'RemovePlayerPacket'
}

pub fn (p &RemovePlayerPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &RemovePlayerPacket) encode_payload(mut w serializer.Writer) {
	w.be_i32(p.eid)
	w.be_i64(p.client_id)
}

pub fn (mut p RemovePlayerPacket) decode_payload(mut r serializer.Reader) ! {
	p.eid = r.be_i32()!
	p.client_id = r.be_i64()!
}
