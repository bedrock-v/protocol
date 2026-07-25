module packets

import serializer

pub struct ResourcePackClientResponsePacket {
pub mut:
	unknown_byte  u8
	unknown_short i16
}

pub fn (p &ResourcePackClientResponsePacket) pid() u16 {
	return 0x09
}

pub fn (p &ResourcePackClientResponsePacket) name() string {
	return 'ResourcePackClientResponsePacket'
}

pub fn (p &ResourcePackClientResponsePacket) can_be_sent_before_login() bool {
	return true
}

pub fn (p &ResourcePackClientResponsePacket) encode_payload(mut w serializer.Writer) {
	w.u8(p.unknown_byte)
	w.be_i16(p.unknown_short)
}

pub fn (mut p ResourcePackClientResponsePacket) decode_payload(mut r serializer.Reader) ! {
	p.unknown_byte = r.u8()!
	p.unknown_short = r.be_i16()!
}
