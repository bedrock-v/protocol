module src

import src.serializer

pub struct RequestPermissionsPacket {
pub mut:
	target_actor_unique_id i64
	player_permission      int
	custom_flags           int
}

pub fn (p &RequestPermissionsPacket) pid() u16 {
	return request_permissions_packet
}

pub fn (p &RequestPermissionsPacket) name() string {
	return 'RequestPermissionsPacket'
}

pub fn (p &RequestPermissionsPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p RequestPermissionsPacket) decode_payload(mut r serializer.Reader) ! {
	p.target_actor_unique_id = r.le_i64()!
	p.player_permission = int(r.read_varint32()!)
	p.custom_flags = int(r.le_u16()!)
}

pub fn (p &RequestPermissionsPacket) encode_payload(mut w serializer.Writer) {
	w.le_i64(p.target_actor_unique_id)
	w.write_varint32(i32(p.player_permission))
	w.le_u16(u16(p.custom_flags))
}
