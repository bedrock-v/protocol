module packets

import serializer
import version.v662.enums

pub struct PlayStatusPacket {
pub mut:
	status enums.PlayStatus
}

pub fn (p &PlayStatusPacket) pid() u16 { return 2 }

pub fn (p &PlayStatusPacket) name() string { return 'PlayStatusPacket' }

pub fn (p &PlayStatusPacket) can_be_sent_before_login() bool { return true }

pub fn (p &PlayStatusPacket) encode_payload(mut w serializer.Writer) {
	p.status.encode(mut w)
}

pub fn (mut p PlayStatusPacket) decode_payload(mut r serializer.Reader) ! {
	p.status = enums.PlayStatus.decode(mut r)!
}
