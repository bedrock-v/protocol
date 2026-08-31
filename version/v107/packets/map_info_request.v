module packets

import protocol.serializer

pub struct MapInfoRequestPacket {
pub mut:
	map_id i32
}

pub fn (p &MapInfoRequestPacket) pid() u16 {
	return 0x44
}

pub fn (p &MapInfoRequestPacket) name() string {
	return 'MapInfoRequestPacket'
}

pub fn (p &MapInfoRequestPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &MapInfoRequestPacket) encode_payload(mut w serializer.Writer) {
	w.write_varint32(p.map_id)
}

pub fn (mut p MapInfoRequestPacket) decode_payload(mut r serializer.Reader) ! {
	p.map_id = r.read_varint32()!
}
