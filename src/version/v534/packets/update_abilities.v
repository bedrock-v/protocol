module packets

import protocol.serializer
import protocol.version.v534.types

pub struct UpdateAbilitiesPacket {
pub mut:
	abilities types.PlayerAbilitiesData
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
	p.abilities.encode(mut w)
}

pub fn (mut p UpdateAbilitiesPacket) decode_payload(mut r serializer.Reader) ! {
	p.abilities = types.PlayerAbilitiesData.decode(mut r)!
}
