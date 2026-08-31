module packets

import protocol.serializer

pub struct PingPacket {
pub mut:
	time i64
}

pub fn (p &PingPacket) pid() u16 {
	return 0x00
}

pub fn (p &PingPacket) name() string {
	return 'PingPacket'
}

pub fn (p &PingPacket) can_be_sent_before_login() bool {
	return true
}

pub fn (p &PingPacket) encode_payload(mut w serializer.Writer) {
	w.be_i64(p.time)
}

pub fn (mut p PingPacket) decode_payload(mut r serializer.Reader) ! {
	p.time = r.be_i64()!
}
