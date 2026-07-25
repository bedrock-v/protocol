module packets

import serializer
import version.v748.enums

pub struct SetMovementAuthorityPacket {
pub mut:
	movement_mode enums.AuthoritativeMovementMode
}

pub fn (p &SetMovementAuthorityPacket) pid() u16 {
	return 319
}

pub fn (p &SetMovementAuthorityPacket) name() string {
	return 'SetMovementAuthorityPacket'
}

pub fn (p &SetMovementAuthorityPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &SetMovementAuthorityPacket) encode_payload(mut w serializer.Writer) {
	p.movement_mode.encode(mut w)
}

pub fn (mut p SetMovementAuthorityPacket) decode_payload(mut r serializer.Reader) ! {
	p.movement_mode = enums.AuthoritativeMovementMode.decode(mut r)!
}
