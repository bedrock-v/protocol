module packets

import protocol.serializer

pub struct EntityFallPacket {
pub mut:
	entity_runtime_id u64
	fall_distance     f32
	bool1             bool
}

pub fn (p &EntityFallPacket) pid() u16 {
	return 37
}

pub fn (p &EntityFallPacket) name() string {
	return 'EntityFallPacket'
}

pub fn (p &EntityFallPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &EntityFallPacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint64(p.entity_runtime_id)
	w.le_f32(p.fall_distance)
	w.bool(p.bool1)
}

pub fn (mut p EntityFallPacket) decode_payload(mut r serializer.Reader) ! {
	p.entity_runtime_id = r.read_varuint64()!
	p.fall_distance = r.le_f32()!
	p.bool1 = r.bool()!
}
