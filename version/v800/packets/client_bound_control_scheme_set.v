module packets

import protocol.serializer
import protocol.version.v800.enums

pub struct ClientBoundControlSchemeSetPacket {
pub mut:
	scheme enums.ControlScheme
}

pub fn (p &ClientBoundControlSchemeSetPacket) pid() u16 {
	return 327
}

pub fn (p &ClientBoundControlSchemeSetPacket) name() string {
	return 'ClientBoundControlSchemeSetPacket'
}

pub fn (p &ClientBoundControlSchemeSetPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &ClientBoundControlSchemeSetPacket) encode_payload(mut w serializer.Writer) {
	p.scheme.encode(mut w)
}

pub fn (mut p ClientBoundControlSchemeSetPacket) decode_payload(mut r serializer.Reader) ! {
	p.scheme = enums.ControlScheme.decode(mut r)!
}
