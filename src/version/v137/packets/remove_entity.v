module packets

import protocol.serializer

pub struct RemoveEntityPacket {
pub mut:
	entity_unique_id i64
}

pub fn (p &RemoveEntityPacket) pid() u16 {
	return 14
}

pub fn (p &RemoveEntityPacket) name() string {
	return 'RemoveEntityPacket'
}

pub fn (p &RemoveEntityPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &RemoveEntityPacket) encode_payload(mut w serializer.Writer) {
	w.write_varint64(p.entity_unique_id)
}

pub fn (mut p RemoveEntityPacket) decode_payload(mut r serializer.Reader) ! {
	p.entity_unique_id = r.read_varint64()!
}
