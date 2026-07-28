module packets

import protocol.serializer

pub struct PhotoInfoRequestPacket {
pub mut:
	photo_id i64
}

pub fn (p &PhotoInfoRequestPacket) pid() u16 {
	return 173
}

pub fn (p &PhotoInfoRequestPacket) name() string {
	return 'PhotoInfoRequestPacket'
}

pub fn (p &PhotoInfoRequestPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &PhotoInfoRequestPacket) encode_payload(mut w serializer.Writer) {
	w.write_varint64(p.photo_id)
}

pub fn (mut p PhotoInfoRequestPacket) decode_payload(mut r serializer.Reader) ! {
	p.photo_id = r.read_varint64()!
}
