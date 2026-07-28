module packets

import protocol.serializer

pub struct EntityEventPacket {
pub mut:
	entity_runtime_id u64
	event             u8
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
	w.write_varuint64(p.entity_runtime_id)
	w.u8(p.event)
	w.write_varint32(p.data)
}

pub fn (mut p EntityEventPacket) decode_payload(mut r serializer.Reader) ! {
	p.entity_runtime_id = r.read_varuint64()!
	p.event = r.u8()!
	p.data = r.read_varint32()!
}
