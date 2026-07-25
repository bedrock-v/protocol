module packets

import serializer
import version.v662.enums

pub struct ContainerSetDataPacket {
pub mut:
	container_id enums.ContainerID
	id           i32
	value        i32
}

pub fn (p &ContainerSetDataPacket) pid() u16 { return 51 }

pub fn (p &ContainerSetDataPacket) name() string { return 'ContainerSetDataPacket' }

pub fn (p &ContainerSetDataPacket) can_be_sent_before_login() bool { return false }

pub fn (p &ContainerSetDataPacket) encode_payload(mut w serializer.Writer) {
	p.container_id.encode(mut w)
	w.write_varint32(p.id)
	w.write_varint32(p.value)
}

pub fn (mut p ContainerSetDataPacket) decode_payload(mut r serializer.Reader) ! {
	p.container_id = enums.ContainerID.decode(mut r)!
	p.id = r.read_varint32()!
	p.value = r.read_varint32()!
}
