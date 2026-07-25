module packets

import serializer

pub struct CameraPacket {
pub mut:
	camera_unique_entity_id i64
	player_unique_entity_id i64
}

pub fn (p &CameraPacket) pid() u16 {
	return 73
}

pub fn (p &CameraPacket) name() string {
	return 'CameraPacket'
}

pub fn (p &CameraPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &CameraPacket) encode_payload(mut w serializer.Writer) {
	w.write_varint64(p.camera_unique_entity_id)
	w.write_varint64(p.player_unique_entity_id)
}

pub fn (mut p CameraPacket) decode_payload(mut r serializer.Reader) ! {
	p.camera_unique_entity_id = r.read_varint64()!
	p.player_unique_entity_id = r.read_varint64()!
}
