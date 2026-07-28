module packets

import protocol.serializer

pub struct ContainerOpenPacket {
pub mut:
	windowid  u8
	type      u8
	slots     i32
	x         i32
	y         u32
	z         i32
	entity_id i32
}

pub fn (p &ContainerOpenPacket) pid() u16 {
	return 0x30
}

pub fn (p &ContainerOpenPacket) name() string {
	return 'ContainerOpenPacket'
}

pub fn (p &ContainerOpenPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &ContainerOpenPacket) encode_payload(mut w serializer.Writer) {
	w.u8(p.windowid)
	w.u8(p.type)
	w.write_varint32(p.slots)
	w.write_varint32(p.x)
	w.write_varuint32(p.y)
	w.write_varint32(p.z)
	w.write_varint32(p.entity_id)
}

pub fn (mut p ContainerOpenPacket) decode_payload(mut r serializer.Reader) ! {
	p.windowid = r.u8()!
	p.type = r.u8()!
	p.slots = r.read_varint32()!
	p.x = r.read_varint32()!
	p.y = r.read_varuint32()!
	p.z = r.read_varint32()!
	p.entity_id = r.read_varint32()!
}
