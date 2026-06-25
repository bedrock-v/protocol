module src

import src.serializer
import src.types

pub struct MobEquipmentPacket {
pub mut:
	actor_runtime_id u64
	item             types.ItemStackWrapper
	inventory_slot   int
	hotbar_slot      int
	window_id        int
}

pub fn (p &MobEquipmentPacket) pid() u16 {
	return mob_equipment_packet
}

pub fn (p &MobEquipmentPacket) name() string {
	return 'MobEquipmentPacket'
}

pub fn (p &MobEquipmentPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p MobEquipmentPacket) decode_payload(mut r serializer.Reader) ! {
	p.actor_runtime_id = r.read_actor_runtime_id()!
	p.item = r.read_network_item_stack_descriptor()!
	p.inventory_slot = int(r.u8()!)
	p.hotbar_slot = int(r.u8()!)
	p.window_id = int(r.u8()!)
}

pub fn (p &MobEquipmentPacket) encode_payload(mut w serializer.Writer) {
	w.write_actor_runtime_id(p.actor_runtime_id)
	w.write_network_item_stack_descriptor(p.item)
	w.u8(u8(p.inventory_slot))
	w.u8(u8(p.hotbar_slot))
	w.u8(u8(p.window_id))
}
