module packets

import protocol.serializer
import protocol.version.v14.types

pub struct BannedPacket {
pub mut:
	server_id i64
}

pub fn (p &BannedPacket) pid() u16 {
	return 0x17
}

pub fn (p &BannedPacket) name() string {
	return 'BannedPacket'
}

pub fn (p &BannedPacket) can_be_sent_before_login() bool {
	return true
}

pub fn (p &BannedPacket) encode_payload(mut w serializer.Writer) {
	w.write_raw(types.raknet_magic)
	w.be_i64(p.server_id)
}

pub fn (mut p BannedPacket) decode_payload(mut r serializer.Reader) ! {
}
