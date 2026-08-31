module packets

import protocol.serializer
import protocol.version.v91.types

pub struct MobArmorEquipmentPacket {
pub mut:
	eid   i32
	slots [4]types.EraBItem
}

pub fn (p &MobArmorEquipmentPacket) pid() u16 {
	return 0x21
}

pub fn (p &MobArmorEquipmentPacket) name() string {
	return 'MobArmorEquipmentPacket'
}

pub fn (p &MobArmorEquipmentPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &MobArmorEquipmentPacket) encode_payload(mut w serializer.Writer) {
	w.write_varint32(p.eid)
	for s in p.slots {
		s.encode(mut w)
	}
}

pub fn (mut p MobArmorEquipmentPacket) decode_payload(mut r serializer.Reader) ! {
	p.eid = r.read_varint32()!
	for i in 0 .. 4 {
		p.slots[i] = types.EraBItem.decode(mut r)!
	}
}
