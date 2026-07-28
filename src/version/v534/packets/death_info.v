module packets

import protocol.serializer

pub struct DeathInfoPacket {
pub mut:
	cause_attack_name string
	messages          []string
}

pub fn (p &DeathInfoPacket) pid() u16 {
	return 189
}

pub fn (p &DeathInfoPacket) name() string {
	return 'DeathInfoPacket'
}

pub fn (p &DeathInfoPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &DeathInfoPacket) encode_payload(mut w serializer.Writer) {
	w.write_string(p.cause_attack_name)
	w.write_varuint32(u32(p.messages.len))
	for message in p.messages {
		w.write_string(message)
	}
}

pub fn (mut p DeathInfoPacket) decode_payload(mut r serializer.Reader) ! {
	p.cause_attack_name = r.read_string()!
	message_count := int(r.read_varuint32()!)
	p.messages = []string{cap: message_count}
	for _ in 0 .. message_count {
		p.messages << r.read_string()!
	}
}
