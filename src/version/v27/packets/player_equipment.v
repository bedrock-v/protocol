module packets

import protocol.serializer

pub struct PlayerEquipmentPacket {
pub mut:
	eid           i64
	item          i16
	meta          i16
	slot          u8
	selected_slot u8
}

pub fn (p &PlayerEquipmentPacket) pid() u16 {
	return 0x98
}

pub fn (p &PlayerEquipmentPacket) name() string {
	return 'PlayerEquipmentPacket'
}

pub fn (p &PlayerEquipmentPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &PlayerEquipmentPacket) encode_payload(mut w serializer.Writer) {
	w.be_i64(p.eid)
	w.be_i16(p.item)
	w.be_i16(p.meta)
	w.u8(p.slot)
	w.u8(p.selected_slot)
}

pub fn (mut p PlayerEquipmentPacket) decode_payload(mut r serializer.Reader) ! {
	p.eid = r.be_i64()!
	p.item = r.be_i16()!
	p.meta = r.be_i16()!
	p.slot = r.u8()!
	p.selected_slot = r.u8()!
}
