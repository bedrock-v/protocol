module packets

import serializer

pub struct PresenceConfiguration {
pub mut:
	rich_presence_id ?string
}

pub fn (t PresenceConfiguration) encode(mut w serializer.Writer) {
	if v := t.rich_presence_id {
		w.bool(true)
		w.write_string(v)
	} else {
		w.bool(false)
	}
}

pub fn PresenceConfiguration.decode(mut r serializer.Reader) !PresenceConfiguration {
	mut t := PresenceConfiguration{}
	if r.bool()! {
		t.rich_presence_id = r.read_string()!
	}
	return t
}

pub struct ServerPresenceInfoPacket {
pub mut:
	presence_configuration ?PresenceConfiguration
}

pub fn (p &ServerPresenceInfoPacket) pid() u16 { return 347 }

pub fn (p &ServerPresenceInfoPacket) name() string { return 'ServerPresenceInfoPacket' }

pub fn (p &ServerPresenceInfoPacket) can_be_sent_before_login() bool { return false }

pub fn (p &ServerPresenceInfoPacket) encode_payload(mut w serializer.Writer) {
	if v := p.presence_configuration {
		w.bool(true)
		v.encode(mut w)
	} else {
		w.bool(false)
	}
}

pub fn (mut p ServerPresenceInfoPacket) decode_payload(mut r serializer.Reader) ! {
	if r.bool()! {
		p.presence_configuration = PresenceConfiguration.decode(mut r)!
	}
}
