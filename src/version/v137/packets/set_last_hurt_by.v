module packets

import protocol.serializer

pub struct SetLastHurtByPacket {
pub mut:
	entity_type_id i32
}

pub fn (p &SetLastHurtByPacket) pid() u16 {
	return 96
}

pub fn (p &SetLastHurtByPacket) name() string {
	return 'SetLastHurtByPacket'
}

pub fn (p &SetLastHurtByPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &SetLastHurtByPacket) encode_payload(mut w serializer.Writer) {
	w.write_varint32(p.entity_type_id)
}

pub fn (mut p SetLastHurtByPacket) decode_payload(mut r serializer.Reader) ! {
	p.entity_type_id = r.read_varint32()!
}
