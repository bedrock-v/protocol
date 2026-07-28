module packets

import protocol.serializer

pub struct ReadyPacket {
pub mut:
	status u8
}

pub fn (p &ReadyPacket) pid() u16 {
	return 0x84
}

pub fn (p &ReadyPacket) name() string {
	return 'ReadyPacket'
}

pub fn (p &ReadyPacket) can_be_sent_before_login() bool {
	return true
}

pub fn (p &ReadyPacket) encode_payload(mut w serializer.Writer) {
	w.u8(p.status)
}

pub fn (mut p ReadyPacket) decode_payload(mut r serializer.Reader) ! {
	p.status = r.u8()!
}
