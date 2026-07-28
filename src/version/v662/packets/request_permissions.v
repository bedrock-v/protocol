module packets

import protocol.serializer
import protocol.version.v662.enums

pub struct RequestPermissionsPacket {
pub mut:
	target_player_raw_id    i64
	player_permission_level enums.PlayerPermissionLevel
	custom_permission_flags u16
}

pub fn (p &RequestPermissionsPacket) pid() u16 {
	return 185
}

pub fn (p &RequestPermissionsPacket) name() string {
	return 'RequestPermissionsPacket'
}

pub fn (p &RequestPermissionsPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &RequestPermissionsPacket) encode_payload(mut w serializer.Writer) {
	w.le_i64(p.target_player_raw_id)
	p.player_permission_level.encode(mut w)
	w.le_u16(p.custom_permission_flags)
}

pub fn (mut p RequestPermissionsPacket) decode_payload(mut r serializer.Reader) ! {
	p.target_player_raw_id = r.le_i64()!
	p.player_permission_level = enums.PlayerPermissionLevel.decode(mut r)!
	p.custom_permission_flags = r.le_u16()!
}
