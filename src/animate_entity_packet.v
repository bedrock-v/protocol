module src

import src.serializer

pub struct AnimateEntityPacket {
pub mut:
	animation               string
	next_state              string
	stop_expression         string
	stop_expression_version int
	controller              string
	blend_out_time          f32
	actor_runtime_ids       []u64
}

pub fn (p &AnimateEntityPacket) pid() u16 {
	return animate_entity_packet
}

pub fn (p &AnimateEntityPacket) name() string {
	return 'AnimateEntityPacket'
}

pub fn (p &AnimateEntityPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p AnimateEntityPacket) decode_payload(mut r serializer.Reader) ! {
	p.animation = r.read_string()!
	p.next_state = r.read_string()!
	p.stop_expression = r.read_string()!
	p.stop_expression_version = int(r.le_i32()!)
	p.controller = r.read_string()!
	p.blend_out_time = r.le_f32()!
	count := int(r.read_varuint32()!)
	p.actor_runtime_ids = []u64{cap: count}
	for _ in 0 .. count {
		p.actor_runtime_ids << r.read_actor_runtime_id()!
	}
}

pub fn (p &AnimateEntityPacket) encode_payload(mut w serializer.Writer) {
	w.write_string(p.animation)
	w.write_string(p.next_state)
	w.write_string(p.stop_expression)
	w.le_i32(i32(p.stop_expression_version))
	w.write_string(p.controller)
	w.le_f32(p.blend_out_time)
	w.write_varuint32(u32(p.actor_runtime_ids.len))
	for id in p.actor_runtime_ids {
		w.write_actor_runtime_id(id)
	}
}
