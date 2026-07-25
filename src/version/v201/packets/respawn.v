module packets

import serializer
import version.v137.types

pub struct RespawnPacket {
pub mut:
	position types.Vector3f
}

pub fn (p &RespawnPacket) pid() u16 {
	return 45
}

pub fn (p &RespawnPacket) name() string {
	return 'RespawnPacket'
}

pub fn (p &RespawnPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &RespawnPacket) encode_payload(mut w serializer.Writer) {
	p.position.encode(mut w)
}

pub fn (mut p RespawnPacket) decode_payload(mut r serializer.Reader) ! {
	p.position = types.Vector3f.decode(mut r)!
}
