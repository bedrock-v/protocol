module packets

import protocol.serializer

pub struct SubClientLoginPacket {
pub mut:
	auth_payload string
	client_jwt   string
}

pub fn (p &SubClientLoginPacket) pid() u16 {
	return 94
}

pub fn (p &SubClientLoginPacket) name() string {
	return 'SubClientLoginPacket'
}

pub fn (p &SubClientLoginPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &SubClientLoginPacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint32(u32(p.auth_payload.len + p.client_jwt.len + 8))
	w.le_i32(i32(p.auth_payload.len))
	w.write_raw(p.auth_payload.bytes())
	w.le_i32(i32(p.client_jwt.len))
	w.write_raw(p.client_jwt.bytes())
}

pub fn (mut p SubClientLoginPacket) decode_payload(mut r serializer.Reader) ! {
	r.read_varuint32()!
	auth_len := r.le_i32()!
	p.auth_payload = r.read_raw(int(auth_len))!.bytestr()
	client_len := r.le_i32()!
	p.client_jwt = r.read_raw(int(client_len))!.bytestr()
}
