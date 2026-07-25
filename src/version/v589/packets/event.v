module packets

import serializer
import version.v589.types

pub struct EventPacket {
pub mut:
	unique_entity_id i64
	use_player_id    bool
	event_data       types.EventData = types.AgentCreatedEventData{}
}

pub fn (p &EventPacket) pid() u16 {
	return 65
}

pub fn (p &EventPacket) name() string {
	return 'EventPacket'
}

pub fn (p &EventPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &EventPacket) encode_payload(mut w serializer.Writer) {
	w.write_varint64(p.unique_entity_id)
	w.write_varint32(p.event_data.id())
	w.bool(p.use_player_id)
	p.event_data.encode_payload(mut w)
}

pub fn (mut p EventPacket) decode_payload(mut r serializer.Reader) ! {
	p.unique_entity_id = r.read_varint64()!
	event_id := r.read_varint32()!
	p.use_player_id = r.bool()!
	p.event_data = types.EventData.decode_payload(event_id, mut r)!
}
