module packets

import serializer

pub struct LoginPacket {
pub mut:
	username  string
	protocol1 i32
	protocol2 i32
	unknown1  i32
	unknown2  string
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
	w.be_i32(p.protocol1)
	w.be_i32(p.protocol2)
	w.be_i32(p.unknown1)
	w.write_string_be(p.unknown2)
}

pub fn (mut p LoginPacket) decode_payload(mut r serializer.Reader) ! {
	p.username = r.read_string_be()!
	p.protocol1 = r.be_i32()!
	p.protocol2 = r.be_i32()!
	p.unknown1 = r.be_i32()!
	p.unknown2 = r.read_string_be()!
}
