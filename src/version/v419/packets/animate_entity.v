module packets

import protocol.serializer

pub struct AnimateEntityPacket {
pub mut:
	animation          string
	next_state         string
	stop_expression    string
	controller         string
	blend_out_time     f32
	runtime_entity_ids []u64
}

pub fn (p &AnimateEntityPacket) pid() u16 {
	return 158
}

pub fn (p &AnimateEntityPacket) name() string {
	return 'AnimateEntityPacket'
}

pub fn (p &AnimateEntityPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &AnimateEntityPacket) encode_payload(mut w serializer.Writer) {
	w.write_string(p.animation)
	w.write_string(p.next_state)
	w.write_string(p.stop_expression)
	w.write_string(p.controller)
	w.le_f32(p.blend_out_time)
	w.write_varuint32(u32(p.runtime_entity_ids.len))
	for runtime_id in p.runtime_entity_ids {
		w.write_varuint64(runtime_id)
	}
}

pub fn (mut p AnimateEntityPacket) decode_payload(mut r serializer.Reader) ! {
	p.animation = r.read_string()!
	p.next_state = r.read_string()!
	p.stop_expression = r.read_string()!
	p.controller = r.read_string()!
	p.blend_out_time = r.le_f32()!
	count := r.read_count()!
	p.runtime_entity_ids = []u64{cap: serializer.prealloc(count)}
	for _ in 0 .. count {
		p.runtime_entity_ids << r.read_varuint64()!
	}
}
