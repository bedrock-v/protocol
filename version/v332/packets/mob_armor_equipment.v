module packets

import protocol.serializer
import protocol.version.v332.types

pub struct MobArmorEquipmentPacket {
pub mut:
	runtime_entity_id u64
	helmet            types.ItemData
	chestplate        types.ItemData
	leggings          types.ItemData
	boots             types.ItemData
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
	w.write_varuint64(p.runtime_entity_id)
	p.helmet.encode(mut w)
	p.chestplate.encode(mut w)
	p.leggings.encode(mut w)
	p.boots.encode(mut w)
}

pub fn (mut p MobArmorEquipmentPacket) decode_payload(mut r serializer.Reader) ! {
	p.runtime_entity_id = r.read_varuint64()!
	p.helmet = types.ItemData.decode(mut r)!
	p.chestplate = types.ItemData.decode(mut r)!
	p.leggings = types.ItemData.decode(mut r)!
	p.boots = types.ItemData.decode(mut r)!
}
