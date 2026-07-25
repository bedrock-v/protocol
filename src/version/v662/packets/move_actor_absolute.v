module packets

import serializer
import version.v662.types

pub struct MoveActorAbsolutePacket {
pub mut:
	move_data types.MoveActorAbsoluteData
}

pub fn (p &MoveActorAbsolutePacket) pid() u16 { return 18 }

pub fn (p &MoveActorAbsolutePacket) name() string { return 'MoveActorAbsolutePacket' }

pub fn (p &MoveActorAbsolutePacket) can_be_sent_before_login() bool { return false }

pub fn (p &MoveActorAbsolutePacket) encode_payload(mut w serializer.Writer) {
	p.move_data.encode(mut w)
}

pub fn (mut p MoveActorAbsolutePacket) decode_payload(mut r serializer.Reader) ! {
	p.move_data = types.MoveActorAbsoluteData.decode(mut r)!
}
