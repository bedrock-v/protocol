module packets

import protocol.serializer

pub struct LoginPacket {
pub mut:
	protocol i32
	payload  []u8
}

pub fn (p &LoginPacket) pid() u16 {
	return 0x01
}

pub fn (p &LoginPacket) name() string {
	return 'LoginPacket'
}

pub fn (p &LoginPacket) can_be_sent_before_login() bool {
	return true
}

pub fn (p &LoginPacket) encode_payload(mut w serializer.Writer) {
	w.be_i32(p.protocol)
	w.be_i32(i32(p.payload.len))
	w.write_raw(p.payload)
}

pub fn (mut p LoginPacket) decode_payload(mut r serializer.Reader) ! {
	p.protocol = r.be_i32()!
	plen := int(r.be_i32()!)
	p.payload = r.read_raw(plen)!
}
