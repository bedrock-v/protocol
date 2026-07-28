module packets

import protocol.serializer

pub struct MapInfoRequestPacket {
pub mut:
	unique_map_id i64
}

pub fn (p &MapInfoRequestPacket) pid() u16 {
	return 68
}

pub fn (p &MapInfoRequestPacket) name() string {
	return 'MapInfoRequestPacket'
}

pub fn (p &MapInfoRequestPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &MapInfoRequestPacket) encode_payload(mut w serializer.Writer) {
	w.write_varint64(p.unique_map_id)
}

pub fn (mut p MapInfoRequestPacket) decode_payload(mut r serializer.Reader) ! {
	p.unique_map_id = r.read_varint64()!
}
