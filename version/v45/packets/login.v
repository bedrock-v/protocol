module packets

import protocol.serializer

pub struct LoginPacket {
pub mut:
	username       string
	protocol1      i32
	protocol2      i32
	client_id      i64
	client_uuid    []u8
	server_address string
	client_secret  string
	skin_name      string
	skin           string
}

pub fn (p &LoginPacket) pid() u16 {
	return 0x8f
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
	w.be_i64(p.client_id)
	w.write_raw(p.client_uuid)
	w.write_string_be(p.server_address)
	w.write_string_be(p.client_secret)
	w.write_string_be(p.skin_name)
	w.write_string_be(p.skin)
}

pub fn (mut p LoginPacket) decode_payload(mut r serializer.Reader) ! {
	p.username = r.read_string_be()!
	p.protocol1 = r.be_i32()!
	p.protocol2 = r.be_i32()!
	p.client_id = r.be_i64()!
	p.client_uuid = r.read_raw(16)!
	p.server_address = r.read_string_be()!
	p.client_secret = r.read_string_be()!
	p.skin_name = r.read_string_be()!
	p.skin = r.read_string_be()!
}
