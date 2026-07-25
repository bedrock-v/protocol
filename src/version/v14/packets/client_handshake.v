module packets

import serializer
import version.v14.types

pub struct ClientHandshakePacket {
pub mut:
	cookie      []u8
	security    u8
	port        u16
	data_array0 []u8
	data_array  [][]u8
	timestamp   []u8
	session2    i64
	session     i64
}

pub fn (p &ClientHandshakePacket) pid() u16 {
	return 0x13
}

pub fn (p &ClientHandshakePacket) name() string {
	return 'ClientHandshakePacket'
}

pub fn (p &ClientHandshakePacket) can_be_sent_before_login() bool {
	return true
}

pub fn (p &ClientHandshakePacket) encode_payload(mut w serializer.Writer) {
	w.write_raw([u8(0x04), 0x3f, 0x57, 0xfe])
	w.u8(0xed)
	w.be_u16(p.port)
	if p.data_array.len > 0 {
		first := p.data_array[0]
		w.u8(u8(first.len))
		w.write_raw(first)
		types.write_data_array(mut w, p.data_array[1..])
	} else {
		w.u8(0)
	}
	w.write_raw([u8(0x00), 0x00])
	w.be_i64(p.session2)
	w.be_i64(p.session)
}

pub fn (mut p ClientHandshakePacket) decode_payload(mut r serializer.Reader) ! {
	p.cookie = r.read_raw(4)!
	p.security = r.u8()!
	p.port = r.be_u16()!
	l := int(r.u8()!)
	p.data_array0 = r.read_raw(l)!
	p.data_array = types.read_data_array(mut r, 9)!
	p.timestamp = r.read_raw(2)!
	p.session2 = r.be_i64()!
	p.session = r.be_i64()!
}
