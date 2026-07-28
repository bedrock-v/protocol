module packets

import protocol.serializer

pub struct SendPartyDestinationCookiePacket {
pub mut:
	cookie           string
	intent           PartyDestinationCookieIntent
	destination_name string
}

pub fn (p &SendPartyDestinationCookiePacket) pid() u16 {
	return 349
}

pub fn (p &SendPartyDestinationCookiePacket) name() string {
	return 'SendPartyDestinationCookiePacket'
}

pub fn (p &SendPartyDestinationCookiePacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &SendPartyDestinationCookiePacket) encode_payload(mut w serializer.Writer) {
	w.write_string(p.cookie)
	p.intent.encode(mut w)
	w.write_string(p.destination_name)
}

pub fn (mut p SendPartyDestinationCookiePacket) decode_payload(mut r serializer.Reader) ! {
	p.cookie = r.read_string()!
	p.intent = PartyDestinationCookieIntent.decode(mut r)!
	p.destination_name = r.read_string()!
}

pub enum PartyDestinationCookieIntent {
	notify
	opt_in
	opt_out
}

pub fn (e PartyDestinationCookieIntent) encode(mut w serializer.Writer) {
	w.write_string(match e {
		.notify { 'notify' }
		.opt_in { 'optin' }
		.opt_out { 'optout' }
	})
}

pub fn PartyDestinationCookieIntent.decode(mut r serializer.Reader) !PartyDestinationCookieIntent {
	s := r.read_string()!
	return match s {
		'notify' { PartyDestinationCookieIntent.notify }
		'optin' { PartyDestinationCookieIntent.opt_in }
		'optout' { PartyDestinationCookieIntent.opt_out }
		else { error('invalid PartyDestinationCookieIntent ${s}') }
	}
}
