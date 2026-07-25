module packets

import serializer

pub struct EntityPickRequestPacket {
pub mut:
	runtime_entity_id u64
	hotbar_slot       u8
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
	w.le_u64(p.runtime_entity_id)
	w.u8(p.hotbar_slot)
}

pub fn (mut p EntityPickRequestPacket) decode_payload(mut r serializer.Reader) ! {
	p.runtime_entity_id = r.le_u64()!
	p.hotbar_slot = r.u8()!
}
