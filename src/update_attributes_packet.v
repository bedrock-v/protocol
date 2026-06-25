module src

import src.serializer
import src.types

pub struct UpdateAttributesPacket {
pub mut:
	actor_runtime_id u64
	entries          []types.UpdateAttribute
	tick             u64
}

pub fn (p &UpdateAttributesPacket) pid() u16 {
	return update_attributes_packet
}

pub fn (p &UpdateAttributesPacket) name() string {
	return 'UpdateAttributesPacket'
}

pub fn (p &UpdateAttributesPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p UpdateAttributesPacket) decode_payload(mut r serializer.Reader) ! {
	p.actor_runtime_id = r.read_actor_runtime_id()!
	count := int(r.read_varuint32()!)
	p.entries = []types.UpdateAttribute{cap: count}
	for _ in 0 .. count {
		p.entries << r.read_update_attribute()!
	}
	p.tick = r.read_varuint64()!
}

pub fn (p &UpdateAttributesPacket) encode_payload(mut w serializer.Writer) {
	w.write_actor_runtime_id(p.actor_runtime_id)
	w.write_varuint32(u32(p.entries.len))
	for entry in p.entries {
		w.write_update_attribute(entry)
	}
	w.write_varuint64(p.tick)
}
