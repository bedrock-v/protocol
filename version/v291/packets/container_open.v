module packets

import protocol.serializer
import protocol.version.v291.types
import protocol.version.v291.enums

pub struct ContainerOpenPacket {
pub mut:
	id               i8
	container_type   enums.ContainerType = enums.ContainerType.@none
	block_position   types.BlockPosition
	unique_entity_id i64
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
	w.i8(p.id)
	p.container_type.encode(mut w)
	p.block_position.encode(mut w)
	w.write_varint64(p.unique_entity_id)
}

pub fn (mut p ContainerOpenPacket) decode_payload(mut r serializer.Reader) ! {
	p.id = r.i8()!
	p.container_type = enums.ContainerType.decode(mut r)!
	p.block_position = types.BlockPosition.decode(mut r)!
	p.unique_entity_id = r.read_varint64()!
}
