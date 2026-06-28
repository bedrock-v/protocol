module protocol

import serializer
import types

pub struct ActorEventPacket {
pub mut:
	actor_runtime_id u64
	event_id         int
	event_data       int
	fire_position    ?types.Vector3
}

pub fn (p &ActorEventPacket) pid() u16 {
	return actor_event_packet
}

pub fn (p &ActorEventPacket) name() string {
	return 'ActorEventPacket'
}

pub fn (p &ActorEventPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p ActorEventPacket) decode_payload(mut r serializer.Reader) ! {
	p.actor_runtime_id = r.read_actor_runtime_id()!
	p.event_id = int(r.u8()!)
	p.event_data = int(r.read_varint32()!)
	if r.bool()! {
		p.fire_position = r.read_vector3()!
	} else {
		p.fire_position = none
	}
}

pub fn (p &ActorEventPacket) encode_payload(mut w serializer.Writer) {
	w.write_actor_runtime_id(p.actor_runtime_id)
	w.u8(u8(p.event_id))
	w.write_varint32(i32(p.event_data))
	if pos := p.fire_position {
		w.bool(true)
		w.write_vector3(pos)
	} else {
		w.bool(false)
	}
}
