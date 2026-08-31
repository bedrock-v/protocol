module packets

import protocol.serializer
import protocol.version.v662.types

pub struct MobArmorEquipmentPacket {
pub mut:
	target_runtime_id types.ActorRuntimeID
	head              types.NetworkItemStackDescriptor
	torso             types.NetworkItemStackDescriptor
	legs              types.NetworkItemStackDescriptor
	feet              types.NetworkItemStackDescriptor
	body              types.NetworkItemStackDescriptor
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
	p.target_runtime_id.encode(mut w)
	p.head.encode(mut w)
	p.torso.encode(mut w)
	p.legs.encode(mut w)
	p.feet.encode(mut w)
	p.body.encode(mut w)
}

pub fn (mut p MobArmorEquipmentPacket) decode_payload(mut r serializer.Reader) ! {
	p.target_runtime_id = types.ActorRuntimeID.decode(mut r)!
	p.head = types.NetworkItemStackDescriptor.decode(mut r)!
	p.torso = types.NetworkItemStackDescriptor.decode(mut r)!
	p.legs = types.NetworkItemStackDescriptor.decode(mut r)!
	p.feet = types.NetworkItemStackDescriptor.decode(mut r)!
	p.body = types.NetworkItemStackDescriptor.decode(mut r)!
}
