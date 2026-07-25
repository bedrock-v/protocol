module packets

import serializer
import version.v662.types as types_662
import version.v975.enums

pub struct ActorEventPacket {
pub mut:
	target_runtime_id types_662.ActorRuntimeID
	event_id          enums.ActorEvent
	data              i32
	fire_at_position  ?[3]f32
}

pub fn (p &ActorEventPacket) pid() u16 { return 27 }

pub fn (p &ActorEventPacket) name() string { return 'ActorEventPacket' }

pub fn (p &ActorEventPacket) can_be_sent_before_login() bool { return false }

pub fn (p &ActorEventPacket) encode_payload(mut w serializer.Writer) {
	p.target_runtime_id.encode(mut w)
	p.event_id.encode(mut w)
	w.write_varint32(p.data)
	if v := p.fire_at_position {
		w.bool(true)
		w.le_f32(v[0])
		w.le_f32(v[1])
		w.le_f32(v[2])
	} else {
		w.bool(false)
	}
}

pub fn (mut p ActorEventPacket) decode_payload(mut r serializer.Reader) ! {
	p.target_runtime_id = types_662.ActorRuntimeID.decode(mut r)!
	p.event_id = enums.ActorEvent.decode(mut r)!
	p.data = r.read_varint32()!
	if r.bool()! {
		p.fire_at_position = [r.le_f32()!, r.le_f32()!, r.le_f32()!]!
	}
}
