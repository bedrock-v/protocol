module packets

import serializer
import version.v662.types
import version.v859.enums

pub struct ActorEventPacket {
pub mut:
	target_runtime_id types.ActorRuntimeID
	event_id          enums.ActorEvent
	data              i32
}

pub fn (p &ActorEventPacket) pid() u16 { return 27 }

pub fn (p &ActorEventPacket) name() string { return 'ActorEventPacket' }

pub fn (p &ActorEventPacket) can_be_sent_before_login() bool { return false }

pub fn (p &ActorEventPacket) encode_payload(mut w serializer.Writer) {
	p.target_runtime_id.encode(mut w)
	p.event_id.encode(mut w)
	w.write_varint32(p.data)
}

pub fn (mut p ActorEventPacket) decode_payload(mut r serializer.Reader) ! {
	p.target_runtime_id = types.ActorRuntimeID.decode(mut r)!
	p.event_id = enums.ActorEvent.decode(mut r)!
	p.data = r.read_varint32()!
}
