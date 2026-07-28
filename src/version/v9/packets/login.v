module packets

import protocol.serializer

pub struct LoginPacket {
pub mut:
	username string
	max_x    i32
	max_y    i32
}

pub fn (p &LoginPacket) pid() u16 {
	return 0x82
}

pub fn (p &LoginPacket) name() string {
	return 'LoginPacket'
}

pub fn (p &LoginPacket) can_be_sent_before_login() bool {
	return true
}

pub fn (p &LoginPacket) encode_payload(mut w serializer.Writer) {
	w.write_string_be(p.username)
	w.be_i32(p.max_x)
	w.be_i32(p.max_y)
}

pub fn (mut p LoginPacket) decode_payload(mut r serializer.Reader) ! {
	p.username = r.read_string_be()!
	p.max_x = r.be_i32()!
	p.max_y = r.be_i32()!
}
