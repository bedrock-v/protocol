module packets

import serializer
import version.v662.types

pub struct CameraPacket {
pub mut:
	camera_id        types.ActorUniqueID
	target_player_id types.ActorUniqueID
}

pub fn (p &CameraPacket) pid() u16 { return 73 }

pub fn (p &CameraPacket) name() string { return 'CameraPacket' }

pub fn (p &CameraPacket) can_be_sent_before_login() bool { return false }

pub fn (p &CameraPacket) encode_payload(mut w serializer.Writer) {
	p.camera_id.encode(mut w)
	p.target_player_id.encode(mut w)
}

pub fn (mut p CameraPacket) decode_payload(mut r serializer.Reader) ! {
	p.camera_id = types.ActorUniqueID.decode(mut r)!
	p.target_player_id = types.ActorUniqueID.decode(mut r)!
}
