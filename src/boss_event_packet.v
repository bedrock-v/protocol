module protocol

import serializer

pub struct BossEventPacket {
pub mut:
	boss_actor_unique_id   i64
	player_actor_unique_id i64
	event_type             int
	title                  string
	filtered_title         string
	health_percent         f32
	color                  int
	overlay                int
}

pub fn (p &BossEventPacket) pid() u16 {
	return boss_event_packet
}

pub fn (p &BossEventPacket) name() string {
	return 'BossEventPacket'
}

pub fn (p &BossEventPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p BossEventPacket) decode_payload(mut r serializer.Reader) ! {
	p.boss_actor_unique_id = r.read_actor_unique_id()!
	p.player_actor_unique_id = r.read_actor_unique_id()!
	p.event_type = int(r.u8()!)
	p.title = r.read_string()!
	p.filtered_title = r.read_string()!
	p.health_percent = r.le_f32()!
	p.color = int(r.u8()!)
	p.overlay = int(r.u8()!)
}

pub fn (p &BossEventPacket) encode_payload(mut w serializer.Writer) {
	w.write_actor_unique_id(p.boss_actor_unique_id)
	w.write_actor_unique_id(p.player_actor_unique_id)
	w.u8(u8(p.event_type))
	w.write_string(p.title)
	w.write_string(p.filtered_title)
	w.le_f32(p.health_percent)
	w.u8(u8(p.color))
	w.u8(u8(p.overlay))
}
