module packets

import protocol.serializer
import protocol.version.v662.types
import protocol.version.v662.enums

pub struct ContainerOpenPacket {
pub mut:
	container_id    enums.ContainerID
	container_type  enums.ContainerType
	position        types.NetworkBlockPosition
	target_actor_id types.ActorUniqueID
}

pub fn (p &ContainerOpenPacket) pid() u16 {
	return 46
}

pub fn (p &ContainerOpenPacket) name() string {
	return 'ContainerOpenPacket'
}

pub fn (p &ContainerOpenPacket) can_be_sent_before_login() bool {
	return false
}

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
	p.target_actor_id = types.ActorUniqueID.decode(mut r)!
}
