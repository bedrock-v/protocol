module protocol

import serializer

pub struct CameraPacket {
pub mut:
	camera_actor_unique_id i64
	player_actor_unique_id i64
}

pub fn (p &CameraPacket) pid() u16 {
	return camera_packet
}

pub fn (p &CameraPacket) name() string {
	return 'CameraPacket'
}

pub fn (p &CameraPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p CameraPacket) decode_payload(mut r serializer.Reader) ! {
	p.camera_actor_unique_id = r.read_actor_unique_id()!
	p.player_actor_unique_id = r.read_actor_unique_id()!
}

pub fn (p &CameraPacket) encode_payload(mut w serializer.Writer) {
	w.write_actor_unique_id(p.camera_actor_unique_id)
	w.write_actor_unique_id(p.player_actor_unique_id)
}
