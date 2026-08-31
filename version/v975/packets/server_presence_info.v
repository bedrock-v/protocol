module packets

import protocol.serializer

pub struct PresenceConfiguration {
pub mut:
	experience_name string
	world_name      string
}

pub fn (t PresenceConfiguration) encode(mut w serializer.Writer) {
	w.write_string(t.experience_name)
	w.write_string(t.world_name)
}

pub fn PresenceConfiguration.decode(mut r serializer.Reader) !PresenceConfiguration {
	return PresenceConfiguration{
		experience_name: r.read_string()!
		world_name:      r.read_string()!
	}
}

pub struct ServerPresenceInfoPacket {
pub mut:
	presence_configuration ?PresenceConfiguration
}

pub fn (p &ServerPresenceInfoPacket) pid() u16 {
	return 347
}

pub fn (p &ServerPresenceInfoPacket) name() string {
	return 'ServerPresenceInfoPacket'
}

pub fn (p &ServerPresenceInfoPacket) can_be_sent_before_login() bool {
	return false
}

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
