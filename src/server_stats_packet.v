module protocol

import serializer

pub struct ServerStatsPacket {
pub mut:
	server_time  f32
	network_time f32
}

pub fn (p &ServerStatsPacket) pid() u16 {
	return server_stats_packet
}

pub fn (p &ServerStatsPacket) name() string {
	return 'ServerStatsPacket'
}

pub fn (p &ServerStatsPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p ServerStatsPacket) decode_payload(mut r serializer.Reader) ! {
	p.server_time = r.le_f32()!
	p.network_time = r.le_f32()!
}

pub fn (p &ServerStatsPacket) encode_payload(mut w serializer.Writer) {
	w.le_f32(p.server_time)
	w.le_f32(p.network_time)
}
