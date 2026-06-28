module protocol

import serializer

pub struct LoginPacket {
pub mut:
	protocol        int
	auth_info_json  string
	client_data_jwt string
}

pub fn (p &LoginPacket) pid() u16 {
	return login_packet
}

pub fn (p &LoginPacket) name() string {
	return 'LoginPacket'
}

pub fn (p &LoginPacket) can_be_sent_before_login() bool {
	return true
}

pub fn (mut p LoginPacket) decode_payload(mut r serializer.Reader) ! {
	p.protocol = int(r.be_u32()!)
	connection_request := r.read_string_bytes()!
	mut cr := serializer.new_reader(connection_request)
	auth_len := int(cr.le_u32()!)
	p.auth_info_json = cr.read_raw(auth_len)!.bytestr()
	jwt_len := int(cr.le_u32()!)
	p.client_data_jwt = cr.read_raw(jwt_len)!.bytestr()
}

pub fn (p &LoginPacket) encode_payload(mut w serializer.Writer) {
	w.be_u32(u32(p.protocol))
	mut cr := serializer.new_writer()
	cr.le_u32(u32(p.auth_info_json.len))
	cr.write_raw(p.auth_info_json.bytes())
	cr.le_u32(u32(p.client_data_jwt.len))
	cr.write_raw(p.client_data_jwt.bytes())
	w.write_string_bytes(cr.bytes())
}
