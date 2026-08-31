module packets

import protocol.serializer

pub struct EntityDataPacket {
pub mut:
	x        i16
	y        u8
	z        i16
	namedtag []u8
}

pub fn (p &EntityDataPacket) pid() u16 {
	return 0xb8
}

pub fn (p &EntityDataPacket) name() string {
	return 'EntityDataPacket'
}

pub fn (p &EntityDataPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &EntityDataPacket) encode_payload(mut w serializer.Writer) {
	w.be_i16(p.x)
	w.u8(p.y)
	w.be_i16(p.z)
	w.write_raw(p.namedtag)
}

pub fn (mut p EntityDataPacket) decode_payload(mut r serializer.Reader) ! {
	p.x = r.be_i16()!
	p.y = r.u8()!
	p.z = r.be_i16()!
	p.namedtag = r.read_raw(r.remaining())!
}
