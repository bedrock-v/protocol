module src

import src.serializer
import src.types

pub struct MobArmorEquipmentPacket {
pub mut:
	actor_runtime_id u64
	head             types.ItemStackWrapper
	chest            types.ItemStackWrapper
	legs             types.ItemStackWrapper
	feet             types.ItemStackWrapper
	body             types.ItemStackWrapper
}

pub fn (p &MobArmorEquipmentPacket) pid() u16 {
	return mob_armor_equipment_packet
}

pub fn (p &MobArmorEquipmentPacket) name() string {
	return 'MobArmorEquipmentPacket'
}

pub fn (p &MobArmorEquipmentPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p MobArmorEquipmentPacket) decode_payload(mut r serializer.Reader) ! {
	p.actor_runtime_id = r.read_actor_runtime_id()!
	p.head = r.read_network_item_stack_descriptor()!
	p.chest = r.read_network_item_stack_descriptor()!
	p.legs = r.read_network_item_stack_descriptor()!
	p.feet = r.read_network_item_stack_descriptor()!
	p.body = r.read_network_item_stack_descriptor()!
}

pub fn (p &MobArmorEquipmentPacket) encode_payload(mut w serializer.Writer) {
	w.write_actor_runtime_id(p.actor_runtime_id)
	w.write_network_item_stack_descriptor(p.head)
	w.write_network_item_stack_descriptor(p.chest)
	w.write_network_item_stack_descriptor(p.legs)
	w.write_network_item_stack_descriptor(p.feet)
	w.write_network_item_stack_descriptor(p.body)
}
