module packets

import protocol.serializer
import protocol.version.v34.types

pub struct MobArmorEquipmentPacket {
pub mut:
	eid   i64
	slots []types.Item
}

pub fn (p &MobArmorEquipmentPacket) pid() u16 {
	return 0xa8
}

pub fn (p &MobArmorEquipmentPacket) name() string {
	return 'MobArmorEquipmentPacket'
}

pub fn (p &MobArmorEquipmentPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &MobArmorEquipmentPacket) encode_payload(mut w serializer.Writer) {
	w.be_i64(p.eid)
	for i in 0 .. 4 {
		if i < p.slots.len {
			p.slots[i].encode(mut w)
		} else {
			empty := types.Item{}
			empty.encode(mut w)
		}
	}
}

pub fn (mut p MobArmorEquipmentPacket) decode_payload(mut r serializer.Reader) ! {
	p.eid = r.be_i64()!
	for _ in 0 .. 4 {
		p.slots << types.Item.decode(mut r)!
	}
}
