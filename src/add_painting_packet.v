module protocol

import serializer
import types

pub struct AddPaintingPacket {
pub mut:
	actor_unique_id  i64
	actor_runtime_id u64
	position         types.Vector3
	direction        int
	title            string
}

pub fn (p &AddPaintingPacket) pid() u16 {
	return add_painting_packet
}

pub fn (p &AddPaintingPacket) name() string {
	return 'AddPaintingPacket'
}

pub fn (p &AddPaintingPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p AddPaintingPacket) decode_payload(mut r serializer.Reader) ! {
	p.actor_unique_id = r.read_actor_unique_id()!
	p.actor_runtime_id = r.read_actor_runtime_id()!
	p.position = r.read_vector3()!
	p.direction = int(r.read_varint32()!)
	p.title = r.read_string()!
}

pub fn (p &AddPaintingPacket) encode_payload(mut w serializer.Writer) {
	w.write_actor_unique_id(p.actor_unique_id)
	w.write_actor_runtime_id(p.actor_runtime_id)
	w.write_vector3(p.position)
	w.write_varint32(i32(p.direction))
	w.write_string(p.title)
}
