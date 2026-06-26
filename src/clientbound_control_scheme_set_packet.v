module src

import src.serializer

pub struct ClientboundControlSchemeSetPacket {
pub mut:
	scheme int
}

pub fn (p &ClientboundControlSchemeSetPacket) pid() u16 {
	return clientbound_control_scheme_set_packet
}

pub fn (p &ClientboundControlSchemeSetPacket) name() string {
	return 'ClientboundControlSchemeSetPacket'
}

pub fn (p &ClientboundControlSchemeSetPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p ClientboundControlSchemeSetPacket) decode_payload(mut r serializer.Reader) ! {
	p.scheme = int(r.u8()!)
}

pub fn (p &ClientboundControlSchemeSetPacket) encode_payload(mut w serializer.Writer) {
	w.u8(u8(p.scheme))
}
