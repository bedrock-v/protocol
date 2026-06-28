module protocol

import serializer

pub struct ShowCreditsPacket {
pub mut:
	player_actor_runtime_id u64
	status                  int
}

pub fn (p &ShowCreditsPacket) pid() u16 {
	return show_credits_packet
}

pub fn (p &ShowCreditsPacket) name() string {
	return 'ShowCreditsPacket'
}

pub fn (p &ShowCreditsPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p ShowCreditsPacket) decode_payload(mut r serializer.Reader) ! {
	p.player_actor_runtime_id = r.read_actor_runtime_id()!
	p.status = int(r.read_varint32()!)
}

pub fn (p &ShowCreditsPacket) encode_payload(mut w serializer.Writer) {
	w.write_actor_runtime_id(p.player_actor_runtime_id)
	w.write_varint32(i32(p.status))
}
