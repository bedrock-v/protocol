module packets

import protocol.serializer

pub struct LoginPacket {
pub mut:
	protocol_version i32
	chain_data       string
	client_jwt       string
}

pub fn (p &LoginPacket) pid() u16 {
	return 1
}

pub fn (p &LoginPacket) name() string {
	return 'LoginPacket'
}

pub fn (p &LoginPacket) can_be_sent_before_login() bool {
	return true
}

pub fn (p &LoginPacket) encode_payload(mut w serializer.Writer) {
	w.be_i32(p.protocol_version)
	w.write_varuint32(u32(p.chain_data.len + p.client_jwt.len + 8))
	w.le_u32(u32(p.chain_data.len))
	w.write_raw(p.chain_data.bytes())
	w.le_u32(u32(p.client_jwt.len))
	w.write_raw(p.client_jwt.bytes())
}

pub fn (mut p LoginPacket) decode_payload(mut r serializer.Reader) ! {
	p.protocol_version = r.be_i32()!
	_ = r.read_varuint32()!
	chain_len := r.le_u32()!
	p.chain_data = r.read_raw(int(chain_len))!.bytestr()
	client_len := r.le_u32()!
	p.client_jwt = r.read_raw(int(client_len))!.bytestr()
}
