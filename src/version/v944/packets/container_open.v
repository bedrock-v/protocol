module packets

import serializer
import version.v662.types as types_662
import version.v662.enums
import version.v944.types

pub struct ContainerOpenPacket {
pub mut:
	container_id    enums.ContainerID
	container_type  enums.ContainerType
	position        types.NetworkBlockPosition
	target_actor_id types_662.ActorUniqueID
}

pub fn (p &ContainerOpenPacket) pid() u16 { return 46 }

pub fn (p &ContainerOpenPacket) name() string { return 'ContainerOpenPacket' }

pub fn (p &ContainerOpenPacket) can_be_sent_before_login() bool { return false }

pub fn (p &ContainerOpenPacket) encode_payload(mut w serializer.Writer) {
	p.container_id.encode(mut w)
	p.container_type.encode(mut w)
	p.position.encode(mut w)
	p.target_actor_id.encode(mut w)
}

pub fn (mut p ContainerOpenPacket) decode_payload(mut r serializer.Reader) ! {
	p.container_id = enums.ContainerID.decode(mut r)!
	p.container_type = enums.ContainerType.decode(mut r)!
	p.position = types.NetworkBlockPosition.decode(mut r)!
	p.target_actor_id = types_662.ActorUniqueID.decode(mut r)!
}
