module src

import src.serializer

pub struct SetLastHurtByPacket {
pub mut:
	entity_type_id int
}

pub fn (p &SetLastHurtByPacket) pid() u16 {
	return set_last_hurt_by_packet
}

pub fn (p &SetLastHurtByPacket) name() string {
	return 'SetLastHurtByPacket'
}

pub fn (p &SetLastHurtByPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p SetLastHurtByPacket) decode_payload(mut r serializer.Reader) ! {
	p.entity_type_id = int(r.read_varint32()!)
}

pub fn (p &SetLastHurtByPacket) encode_payload(mut w serializer.Writer) {
	w.write_varint32(i32(p.entity_type_id))
}
