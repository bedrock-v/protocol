module packets

import protocol.serializer

pub struct DropItemPacket {
pub mut:
	eid      i32
	unknown1 u8
	block    u16
	stack    u8
	meta     u16
}

pub fn (p &DropItemPacket) pid() u16 {
	return 0xae
}

pub fn (p &DropItemPacket) name() string {
	return 'DropItemPacket'
}

pub fn (p &DropItemPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &DropItemPacket) encode_payload(mut w serializer.Writer) {
	w.be_i32(p.eid)
	w.u8(p.unknown1)
	w.be_u16(p.block)
	w.u8(p.stack)
	w.be_u16(p.meta)
}

pub fn (mut p DropItemPacket) decode_payload(mut r serializer.Reader) ! {
	p.eid = r.be_i32()!
	p.unknown1 = r.u8()!
	p.block = r.be_u16()!
	p.stack = r.u8()!
	p.meta = r.be_u16()!
}
