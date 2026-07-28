module packets

import protocol.serializer

pub struct SetLocalPlayerAsInitializedPacket {
pub mut:
	entity_runtime_id u64
}

pub fn (p &SetLocalPlayerAsInitializedPacket) pid() u16 {
	return 112
}

pub fn (p &SetLocalPlayerAsInitializedPacket) name() string {
	return 'SetLocalPlayerAsInitializedPacket'
}

pub fn (p &SetLocalPlayerAsInitializedPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &SetLocalPlayerAsInitializedPacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint64(p.entity_runtime_id)
}

pub fn (mut p SetLocalPlayerAsInitializedPacket) decode_payload(mut r serializer.Reader) ! {
	p.entity_runtime_id = r.read_varuint64()!
}
