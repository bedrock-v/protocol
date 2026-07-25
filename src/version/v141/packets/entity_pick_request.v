module packets

import serializer

pub struct EntityPickRequestPacket {
pub mut:
	entity_unique_id i64
	hotbar_slot      u8
}

pub fn (p &EntityPickRequestPacket) pid() u16 {
	return 35
}

pub fn (p &EntityPickRequestPacket) name() string {
	return 'EntityPickRequestPacket'
}

pub fn (p &EntityPickRequestPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &EntityPickRequestPacket) encode_payload(mut w serializer.Writer) {
	w.le_i64(p.entity_unique_id)
	w.u8(p.hotbar_slot)
}

pub fn (mut p EntityPickRequestPacket) decode_payload(mut r serializer.Reader) ! {
	p.entity_unique_id = r.le_i64()!
	p.hotbar_slot = r.u8()!
}
