module packets

import protocol.serializer
import protocol.version.v14.types

pub struct ServerFullPacket {
pub mut:
	server_id i64
}

pub fn (p &ServerFullPacket) pid() u16 {
	return 0x14
}

pub fn (p &ServerFullPacket) name() string {
	return 'ServerFullPacket'
}

pub fn (p &ServerFullPacket) can_be_sent_before_login() bool {
	return true
}

pub fn (p &ServerFullPacket) encode_payload(mut w serializer.Writer) {
	w.write_raw(types.raknet_magic)
	w.be_i64(p.server_id)
}

pub fn (mut p ServerFullPacket) decode_payload(mut r serializer.Reader) ! {
}
