module packets

import protocol.serializer
import protocol.version.v34.types

pub struct MobEquipmentPacket {
pub mut:
	eid           i64
	item          types.Item
	slot          u8
	selected_slot u8
}

pub fn (p &MobEquipmentPacket) pid() u16 {
	return 0xa7
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
	p.item = types.Item.decode(mut r)!
	p.slot = r.u8()!
	p.selected_slot = r.u8()!
}
