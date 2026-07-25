module packets

import serializer
import version.v14.types

pub struct ServerHandshakePacket {
pub mut:
	cookie     []u8
	security   u8
	port       u16
	data_array [][]u8
	timestamp  []u8
	session    i64
	session2   i64
}

pub fn (p &ServerHandshakePacket) pid() u16 {
	return 0x10
}

pub fn (p &ServerHandshakePacket) name() string {
	return 'ServerHandshakePacket'
}

pub fn (p &ServerHandshakePacket) can_be_sent_before_login() bool {
	return true
}

pub fn (p &ServerHandshakePacket) encode_payload(mut w serializer.Writer) {
	w.write_raw([u8(0x04), 0x3f, 0x57, 0xfe])
	w.u8(0xcd)
	w.be_u16(p.port)
	types.write_data_array(mut w, [
		[u8(0xf5), 0xff, 0xff, 0xf5],
		[u8(0xff), 0xff, 0xff, 0xff],
		[u8(0xff), 0xff, 0xff, 0xff],
		[u8(0xff), 0xff, 0xff, 0xff],
		[u8(0xff), 0xff, 0xff, 0xff],
		[u8(0xff), 0xff, 0xff, 0xff],
		[u8(0xff), 0xff, 0xff, 0xff],
		[u8(0xff), 0xff, 0xff, 0xff],
		[u8(0xff), 0xff, 0xff, 0xff],
		[u8(0xff), 0xff, 0xff, 0xff],
	])
	w.write_raw([u8(0x00), 0x00])
	w.be_i64(p.session)
	w.be_i64(p.session2)
}

pub fn (mut p ServerHandshakePacket) decode_payload(mut r serializer.Reader) ! {
	p.cookie = r.read_raw(4)!
	p.security = r.u8()!
	p.port = r.be_u16()!
	p.data_array = types.read_data_array(mut r, 10)!
	p.timestamp = r.read_raw(2)!
	p.session = r.be_i64()!
	p.session2 = r.be_i64()!
}
