module packets

import protocol.serializer
import protocol.version.v776.types

pub struct UpdateAbilitiesPacket {
pub mut:
	data types.SerializedAbilitiesData
}

pub fn (p &UpdateAbilitiesPacket) pid() u16 {
	return 187
}

pub fn (p &UpdateAbilitiesPacket) name() string {
	return 'UpdateAbilitiesPacket'
}

pub fn (p &UpdateAbilitiesPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &UpdateAbilitiesPacket) encode_payload(mut w serializer.Writer) {
	p.data.encode(mut w)
}

pub fn (mut p UpdateAbilitiesPacket) decode_payload(mut r serializer.Reader) ! {
	p.data = types.SerializedAbilitiesData.decode(mut r)!
}
