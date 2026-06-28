module protocol

import serializer
import types

pub struct ChangeDimensionPacket {
pub mut:
	dimension         int
	position          types.Vector3
	respawn           bool
	loading_screen_id ?u32
}

pub fn (p &ChangeDimensionPacket) pid() u16 {
	return change_dimension_packet
}

pub fn (p &ChangeDimensionPacket) name() string {
	return 'ChangeDimensionPacket'
}

pub fn (p &ChangeDimensionPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p ChangeDimensionPacket) decode_payload(mut r serializer.Reader) ! {
	p.dimension = int(r.read_varint32()!)
	p.position = r.read_vector3()!
	p.respawn = r.bool()!
	if r.bool()! {
		p.loading_screen_id = r.le_u32()!
	} else {
		p.loading_screen_id = none
	}
}

pub fn (p &ChangeDimensionPacket) encode_payload(mut w serializer.Writer) {
	w.write_varint32(i32(p.dimension))
	w.write_vector3(p.position)
	w.bool(p.respawn)
	if id := p.loading_screen_id {
		w.bool(true)
		w.le_u32(id)
	} else {
		w.bool(false)
	}
}
