module src

import src.serializer

pub struct SendPartyDestinationCookiePacket {
pub mut:
	cookie           string
	intent           string
	destination_name string
}

pub fn (p &SendPartyDestinationCookiePacket) pid() u16 {
	return send_party_destination_cookie_packet
}

pub fn (p &SendPartyDestinationCookiePacket) name() string {
	return 'SendPartyDestinationCookiePacket'
}

pub fn (p &SendPartyDestinationCookiePacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p SendPartyDestinationCookiePacket) decode_payload(mut r serializer.Reader) ! {
	p.cookie = r.read_string()!
	p.intent = r.read_string()!
	p.destination_name = r.read_string()!
}

pub fn (p &SendPartyDestinationCookiePacket) encode_payload(mut w serializer.Writer) {
	w.write_string(p.cookie)
	w.write_string(p.intent)
	w.write_string(p.destination_name)
}
