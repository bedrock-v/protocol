module packets

import serializer

pub struct RemovePlayerPacket {
pub mut:
	eid         i64
	client_uuid []u8
}

pub fn (p &RemovePlayerPacket) pid() u16 {
	return 0x97
}

pub fn (p &RemovePlayerPacket) name() string {
	return 'RemovePlayerPacket'
}

pub fn (p &RemovePlayerPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &RemovePlayerPacket) encode_payload(mut w serializer.Writer) {
	w.be_i64(p.eid)
	w.write_raw(p.client_uuid)
}

pub fn (mut p RemovePlayerPacket) decode_payload(mut r serializer.Reader) ! {
	p.eid = r.be_i64()!
	p.client_uuid = r.read_raw(16)!
}
