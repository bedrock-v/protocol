module packets

import protocol.serializer

pub struct EntityEventPacket {
pub mut:
	eid   i32
	event u8
}

pub fn (p &EntityEventPacket) pid() u16 {
	return 0x9c
}

pub fn (p &EntityEventPacket) name() string {
	return 'EntityEventPacket'
}

pub fn (p &EntityEventPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &EntityEventPacket) encode_payload(mut w serializer.Writer) {
	w.be_i32(p.eid)
	w.u8(p.event)
}

pub fn (mut p EntityEventPacket) decode_payload(mut r serializer.Reader) ! {
	p.eid = r.be_i32()!
	p.event = r.u8()!
}
