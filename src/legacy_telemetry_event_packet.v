module protocol

import serializer

pub struct LegacyTelemetryEventPacket {
pub mut:
	player_runtime_id u64
	event_data        int
	type              u8
}

pub fn (p &LegacyTelemetryEventPacket) pid() u16 {
	return legacy_telemetry_event_packet
}

pub fn (p &LegacyTelemetryEventPacket) name() string {
	return 'LegacyTelemetryEventPacket'
}

pub fn (p &LegacyTelemetryEventPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p LegacyTelemetryEventPacket) decode_payload(mut r serializer.Reader) ! {
	p.player_runtime_id = r.read_actor_runtime_id()!
	p.event_data = r.read_varint32()!
	p.type = r.u8()!
}

pub fn (p &LegacyTelemetryEventPacket) encode_payload(mut w serializer.Writer) {
	w.write_actor_runtime_id(p.player_runtime_id)
	w.write_varint32(p.event_data)
	w.u8(p.type)
}
