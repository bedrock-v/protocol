module packets

import protocol.serializer
import protocol.version.v534.types as types_534

pub struct ClientCheatAbilityPacket {
pub mut:
	abilities types_534.PlayerAbilitiesData
}

pub fn (p &ClientCheatAbilityPacket) pid() u16 {
	return 197
}

pub fn (p &ClientCheatAbilityPacket) name() string {
	return 'ClientCheatAbilityPacket'
}

pub fn (p &ClientCheatAbilityPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &ClientCheatAbilityPacket) encode_payload(mut w serializer.Writer) {
	p.abilities.encode(mut w)
}

pub fn (mut p ClientCheatAbilityPacket) decode_payload(mut r serializer.Reader) ! {
	p.abilities = types_534.PlayerAbilitiesData.decode(mut r)!
}
