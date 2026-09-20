module packets

import protocol.serializer
import protocol.types

pub struct RecordStartedPacket {
pub mut:
	position            types.NetworkBlockPosition
	server_sound_handle u64
}

pub fn (p &RecordStartedPacket) pid() u16 {
	return 352
}

pub fn (p &RecordStartedPacket) name() string {
	return 'RecordStartedPacket'
}

pub fn (p &RecordStartedPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &RecordStartedPacket) encode_payload(mut w serializer.Writer) {
	p.position.encode(mut w)
	w.le_u64(p.server_sound_handle)
}

pub fn (mut p RecordStartedPacket) decode_payload(mut r serializer.Reader) ! {
	p.position = types.NetworkBlockPosition.decode(mut r)!
	p.server_sound_handle = r.le_u64()!
}
