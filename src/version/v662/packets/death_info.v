module packets

import protocol.serializer

pub struct DeathInfoPacket {
pub mut:
	death_cause_attack_name  string
	death_cause_message_list []string
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
	w.write_string(p.death_cause_attack_name)
	w.write_varuint32(u32(p.death_cause_message_list.len))
	for e in p.death_cause_message_list {
		w.write_string(e)
	}
}

pub fn (mut p DeathInfoPacket) decode_payload(mut r serializer.Reader) ! {
	p.death_cause_attack_name = r.read_string()!
	{
		count := r.read_count()!
		p.death_cause_message_list = []string{cap: serializer.prealloc(count)}
		for _ in 0 .. count {
			p.death_cause_message_list << r.read_string()!
		}
	}
}
