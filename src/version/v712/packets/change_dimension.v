module packets

import serializer

pub struct ChangeDimensionPacket {
pub mut:
	dimension_id      i32
	position          [3]f32
	respawn           bool
	loading_screen_id ?i32
}

pub fn (p &ChangeDimensionPacket) pid() u16 { return 61 }

pub fn (p &ChangeDimensionPacket) name() string { return 'ChangeDimensionPacket' }

pub fn (p &ChangeDimensionPacket) can_be_sent_before_login() bool { return false }

pub fn (p &ChangeDimensionPacket) encode_payload(mut w serializer.Writer) {
	w.write_varint32(p.dimension_id)
	w.le_f32(p.position[0])
	w.le_f32(p.position[1])
	w.le_f32(p.position[2])
	w.bool(p.respawn)
	if v := p.loading_screen_id {
		w.bool(true)
		w.le_i32(v)
	} else {
		w.bool(false)
	}
}

pub fn (mut p ChangeDimensionPacket) decode_payload(mut r serializer.Reader) ! {
	p.dimension_id = r.read_varint32()!
	p.position = [r.le_f32()!, r.le_f32()!, r.le_f32()!]!
	p.respawn = r.bool()!
	if r.bool()! {
		p.loading_screen_id = r.le_i32()!
	} else {
		p.loading_screen_id = none
	}
}
