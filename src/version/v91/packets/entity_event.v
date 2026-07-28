module packets

import protocol.serializer

pub struct EntityEventPacket {
pub mut:
	eid     i32
	event   u8
	unknown i32
}

pub fn (p &EntityEventPacket) pid() u16 {
	return 0x1d
}

pub fn (p &EntityEventPacket) name() string {
	return 'EntityEventPacket'
}

pub fn (p &EntityEventPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &EntityEventPacket) encode_payload(mut w serializer.Writer) {
	w.write_varint32(p.eid)
	w.u8(p.event)
	w.write_varint32(p.unknown)
}

pub fn (mut p EntityEventPacket) decode_payload(mut r serializer.Reader) ! {
	p.eid = r.read_varint32()!
	p.event = r.u8()!
	p.unknown = r.read_varint32()!
}
