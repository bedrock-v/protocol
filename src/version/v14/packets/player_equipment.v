module packets

import serializer

pub struct PlayerEquipmentPacket {
pub mut:
	eid   i32
	block u16
	meta  u16
	slot  u8
}

pub fn (p &PlayerEquipmentPacket) pid() u16 {
	return 0xa0
}

pub fn (p &PlayerEquipmentPacket) name() string {
	return 'PlayerEquipmentPacket'
}

pub fn (p &PlayerEquipmentPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &PlayerEquipmentPacket) encode_payload(mut w serializer.Writer) {
	w.be_i32(p.eid)
	w.be_u16(p.block)
	w.be_u16(p.meta)
	w.u8(p.slot)
}

pub fn (mut p PlayerEquipmentPacket) decode_payload(mut r serializer.Reader) ! {
	p.eid = r.be_i32()!
	p.block = r.be_u16()!
	p.meta = r.be_u16()!
	p.slot = r.u8()!
}
