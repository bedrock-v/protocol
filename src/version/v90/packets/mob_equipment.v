module packets

import serializer
import version.v90.types

pub struct MobEquipmentPacket {
pub mut:
	eid           i64
	item          types.EraBItem
	slot          u8
	selected_slot u8
}

pub fn (p &MobEquipmentPacket) pid() u16 {
	return 0x1d
}

pub fn (p &MobEquipmentPacket) name() string {
	return 'MobEquipmentPacket'
}

pub fn (p &MobEquipmentPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &MobEquipmentPacket) encode_payload(mut w serializer.Writer) {
	w.be_i64(p.eid)
	p.item.encode(mut w)
	w.u8(p.slot)
	w.u8(p.selected_slot)
}

pub fn (mut p MobEquipmentPacket) decode_payload(mut r serializer.Reader) ! {
	p.eid = r.be_i64()!
	p.item = types.EraBItem.decode(mut r)!
	p.slot = r.u8()!
	p.selected_slot = r.u8()!
}
