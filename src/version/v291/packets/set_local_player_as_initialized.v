module packets

import serializer

pub struct SetLocalPlayerAsInitializedPacket {
pub mut:
	runtime_entity_id u64
}

pub fn (p &SetLocalPlayerAsInitializedPacket) pid() u16 {
	return 113
}

pub fn (p &SetLocalPlayerAsInitializedPacket) name() string {
	return 'SetLocalPlayerAsInitializedPacket'
}

pub fn (p &SetLocalPlayerAsInitializedPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &SetLocalPlayerAsInitializedPacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint64(p.runtime_entity_id)
}

pub fn (mut p SetLocalPlayerAsInitializedPacket) decode_payload(mut r serializer.Reader) ! {
	p.runtime_entity_id = r.read_varuint64()!
}
