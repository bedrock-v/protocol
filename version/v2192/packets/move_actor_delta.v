module packets

import protocol.serializer
import protocol.version.v2192.types

pub struct MoveActorDeltaPacket {
pub mut:
	move_data types.MoveActorDeltaData
}

pub fn (p &MoveActorDeltaPacket) pid() u16 {
	return 111
}

pub fn (p &MoveActorDeltaPacket) name() string {
	return 'MoveActorDeltaPacket'
}

pub fn (p &MoveActorDeltaPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &MoveActorDeltaPacket) encode_payload(mut w serializer.Writer) {
	p.move_data.encode(mut w)
}

pub fn (mut p MoveActorDeltaPacket) decode_payload(mut r serializer.Reader) ! {
	p.move_data = types.MoveActorDeltaData.decode(mut r)!
}
