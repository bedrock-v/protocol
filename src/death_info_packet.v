module protocol

import serializer

pub struct DeathInfoPacket {
pub mut:
	message_translation_key string
	message_parameters      []string
}

pub fn (p &DeathInfoPacket) pid() u16 {
	return death_info_packet
}

pub fn (p &DeathInfoPacket) name() string {
	return 'DeathInfoPacket'
}

pub fn (p &DeathInfoPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p DeathInfoPacket) decode_payload(mut r serializer.Reader) ! {
	p.message_translation_key = r.read_string()!
	count := int(r.read_varuint32()!)
	p.message_parameters = []string{cap: count}
	for _ in 0 .. count {
		p.message_parameters << r.read_string()!
	}
}

pub fn (p &DeathInfoPacket) encode_payload(mut w serializer.Writer) {
	w.write_string(p.message_translation_key)
	w.write_varuint32(u32(p.message_parameters.len))
	for param in p.message_parameters {
		w.write_string(param)
	}
}
