module protocol

import serializer

pub struct PartyDestinationCookieResponsePacket {
pub mut:
	cookie   string
	accepted bool
}

pub fn (p &PartyDestinationCookieResponsePacket) pid() u16 {
	return party_destination_cookie_response_packet
}

pub fn (p &PartyDestinationCookieResponsePacket) name() string {
	return 'PartyDestinationCookieResponsePacket'
}

pub fn (p &PartyDestinationCookieResponsePacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p PartyDestinationCookieResponsePacket) decode_payload(mut r serializer.Reader) ! {
	p.cookie = r.read_string()!
	p.accepted = r.bool()!
}

pub fn (p &PartyDestinationCookieResponsePacket) encode_payload(mut w serializer.Writer) {
	w.write_string(p.cookie)
	w.bool(p.accepted)
}
