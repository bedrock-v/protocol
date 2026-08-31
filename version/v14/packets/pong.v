module packets

import protocol.serializer

pub struct PongPacket {
pub mut:
	ptime i64
	time  i64
}

pub fn (p &PongPacket) pid() u16 {
	return 0x03
}

pub fn (p &PongPacket) name() string {
	return 'PongPacket'
}

pub fn (p &PongPacket) can_be_sent_before_login() bool {
	return true
}

pub fn (p &PongPacket) encode_payload(mut w serializer.Writer) {
	w.be_i64(p.ptime)
	w.be_i64(p.time)
}

pub fn (mut p PongPacket) decode_payload(mut r serializer.Reader) ! {
	p.ptime = r.be_i64()!
	p.time = r.be_i64()!
}
