module packets

import protocol.serializer
import protocol.version.v137.types

pub struct MobArmorEquipmentPacket {
pub mut:
	entity_runtime_id u64
	slots             [4]types.ItemData
}

pub fn (p &MobArmorEquipmentPacket) pid() u16 {
	return 32
}

pub fn (p &MobArmorEquipmentPacket) name() string {
	return 'MobArmorEquipmentPacket'
}

pub fn (p &MobArmorEquipmentPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &MobArmorEquipmentPacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint64(p.entity_runtime_id)
	for slot in p.slots {
		slot.encode(mut w)
	}
}

pub fn (mut p MobArmorEquipmentPacket) decode_payload(mut r serializer.Reader) ! {
	p.entity_runtime_id = r.read_varuint64()!
	for i in 0 .. 4 {
		p.slots[i] = types.ItemData.decode(mut r)!
	}
}
