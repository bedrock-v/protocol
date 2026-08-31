module packets

import protocol.serializer
import protocol.version.v313.enums

pub struct EntityEventPacket {
pub mut:
	runtime_entity_id u64
	event_type        enums.EntityEventType = enums.EntityEventType.@none
	data              i32
}

pub fn (p &EntityEventPacket) pid() u16 {
	return 27
}

pub fn (p &EntityEventPacket) name() string {
	return 'EntityEventPacket'
}

pub fn (p &EntityEventPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &EntityEventPacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint64(p.runtime_entity_id)
	p.event_type.encode(mut w)
	w.write_varint32(p.data)
}

pub fn (mut p EntityEventPacket) decode_payload(mut r serializer.Reader) ! {
	p.runtime_entity_id = r.read_varuint64()!
	p.event_type = enums.EntityEventType.decode(mut r)!
	p.data = r.read_varint32()!
}
