module packets

import serializer
import version.v662.types
import version.v662.enums

pub struct MobEquipmentPacket {
pub mut:
	target_runtime_id types.ActorRuntimeID
	item              types.NetworkItemStackDescriptor
	slot              i8
	selected_slot     i8
	container_id      enums.ContainerID
}

pub fn (p &MobEquipmentPacket) pid() u16 { return 31 }

pub fn (p &MobEquipmentPacket) name() string { return 'MobEquipmentPacket' }

pub fn (p &MobEquipmentPacket) can_be_sent_before_login() bool { return false }

pub fn (p &MobEquipmentPacket) encode_payload(mut w serializer.Writer) {
	p.target_runtime_id.encode(mut w)
	p.item.encode(mut w)
	w.i8(p.slot)
	w.i8(p.selected_slot)
	p.container_id.encode(mut w)
}

pub fn (mut p MobEquipmentPacket) decode_payload(mut r serializer.Reader) ! {
	p.target_runtime_id = types.ActorRuntimeID.decode(mut r)!
	p.item = types.NetworkItemStackDescriptor.decode(mut r)!
	p.slot = r.i8()!
	p.selected_slot = r.i8()!
	p.container_id = enums.ContainerID.decode(mut r)!
}
