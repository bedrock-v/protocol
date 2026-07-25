module packets

import serializer
import version.v90.types

pub struct MobArmorEquipmentPacket {
pub mut:
	eid   i64
	slots [4]types.EraBItem
}

pub fn (p &MobArmorEquipmentPacket) pid() u16 {
	return 0x1e
}

pub fn (p &MobArmorEquipmentPacket) name() string {
	return 'MobArmorEquipmentPacket'
}

pub fn (p &MobArmorEquipmentPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &MobArmorEquipmentPacket) encode_payload(mut w serializer.Writer) {
	w.be_i64(p.eid)
	for s in p.slots {
		s.encode(mut w)
	}
}

pub fn (mut p MobArmorEquipmentPacket) decode_payload(mut r serializer.Reader) ! {
	p.eid = r.be_i64()!
	for i in 0 .. 4 {
		p.slots[i] = types.EraBItem.decode(mut r)!
	}
}
