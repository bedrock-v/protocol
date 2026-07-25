module packets

import serializer

pub struct RiderJumpPacket {
pub mut:
	unknown i32
}

pub fn (p &RiderJumpPacket) pid() u16 {
	return 0x15
}

pub fn (p &RiderJumpPacket) name() string {
	return 'RiderJumpPacket'
}

pub fn (p &RiderJumpPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &RiderJumpPacket) encode_payload(mut w serializer.Writer) {
	w.write_varint32(p.unknown)
}

pub fn (mut p RiderJumpPacket) decode_payload(mut r serializer.Reader) ! {
	p.unknown = r.read_varint32()!
}
