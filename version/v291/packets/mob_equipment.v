module packets

import protocol.serializer
import protocol.version.v291.types

pub struct MobEquipmentPacket {
pub mut:
	runtime_entity_id u64
	item              types.ItemData
	inventory_slot    u8
	hotbar_slot       u8
	container_id      i8
}

pub fn (p &MobEquipmentPacket) pid() u16 {
	return 31
}

pub fn (p &MobEquipmentPacket) name() string {
	return 'MobEquipmentPacket'
}

pub fn (p &MobEquipmentPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &MobEquipmentPacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint64(p.runtime_entity_id)
	p.item.encode(mut w)
	w.u8(p.inventory_slot)
	w.u8(p.hotbar_slot)
	w.i8(p.container_id)
}

pub fn (mut p MobEquipmentPacket) decode_payload(mut r serializer.Reader) ! {
	p.runtime_entity_id = r.read_varuint64()!
	p.item = types.ItemData.decode(mut r)!
	p.inventory_slot = r.u8()!
	p.hotbar_slot = r.u8()!
	p.container_id = r.i8()!
}
