module packets

import serializer
import version.v2168.types
import version.v662.types as types_662

pub struct MobArmorEquipmentPacket {
pub mut:
	target_runtime_id types_662.ActorRuntimeID
	head              types.NetworkItemStackDescriptorV2
	torso             types.NetworkItemStackDescriptorV2
	legs              types.NetworkItemStackDescriptorV2
	feet              types.NetworkItemStackDescriptorV2
	body              types.NetworkItemStackDescriptorV2
}

pub fn (p &MobArmorEquipmentPacket) pid() u16 { return 32 }

pub fn (p &MobArmorEquipmentPacket) name() string { return 'MobArmorEquipmentPacket' }

pub fn (p &MobArmorEquipmentPacket) can_be_sent_before_login() bool { return false }

pub fn (p &MobArmorEquipmentPacket) encode_payload(mut w serializer.Writer) {
	p.target_runtime_id.encode(mut w)
	p.head.encode(mut w)
	p.torso.encode(mut w)
	p.legs.encode(mut w)
	p.feet.encode(mut w)
	p.body.encode(mut w)
}

pub fn (mut p MobArmorEquipmentPacket) decode_payload(mut r serializer.Reader) ! {
	p.target_runtime_id = types_662.ActorRuntimeID.decode(mut r)!
	p.head = types.NetworkItemStackDescriptorV2.decode(mut r)!
	p.torso = types.NetworkItemStackDescriptorV2.decode(mut r)!
	p.legs = types.NetworkItemStackDescriptorV2.decode(mut r)!
	p.feet = types.NetworkItemStackDescriptorV2.decode(mut r)!
	p.body = types.NetworkItemStackDescriptorV2.decode(mut r)!
}
