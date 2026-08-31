module packets

import protocol.serializer

pub struct PlayerArmorEquipmentPacket {
pub mut:
	eid   i32
	slot0 u8
	slot1 u8
	slot2 u8
	slot3 u8
}

pub fn (p &PlayerArmorEquipmentPacket) pid() u16 {
	return 0xa1
}

pub fn (p &PlayerArmorEquipmentPacket) name() string {
	return 'PlayerArmorEquipmentPacket'
}

pub fn (p &PlayerArmorEquipmentPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &PlayerArmorEquipmentPacket) encode_payload(mut w serializer.Writer) {
	w.be_i32(p.eid)
	w.u8(p.slot0)
	w.u8(p.slot1)
	w.u8(p.slot2)
	w.u8(p.slot3)
}

pub fn (mut p PlayerArmorEquipmentPacket) decode_payload(mut r serializer.Reader) ! {
	p.eid = r.be_i32()!
	p.slot0 = r.u8()!
	p.slot1 = r.u8()!
	p.slot2 = r.u8()!
	p.slot3 = r.u8()!
}
