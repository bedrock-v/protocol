module packets

import serializer
import version.v662.types

pub struct AddPaintingPacket {
pub mut:
	target_actor_id   types.ActorUniqueID
	target_runtime_id types.ActorRuntimeID
	position          [3]f32
	direction         i32
	motif             string
}

pub fn (p &AddPaintingPacket) pid() u16 { return 22 }

pub fn (p &AddPaintingPacket) name() string { return 'AddPaintingPacket' }

pub fn (p &AddPaintingPacket) can_be_sent_before_login() bool { return false }

pub fn (p &AddPaintingPacket) encode_payload(mut w serializer.Writer) {
	p.target_actor_id.encode(mut w)
	p.target_runtime_id.encode(mut w)
	w.le_f32(p.position[0])
	w.le_f32(p.position[1])
	w.le_f32(p.position[2])
	w.write_varint32(p.direction)
	w.write_string(p.motif)
}

pub fn (mut p AddPaintingPacket) decode_payload(mut r serializer.Reader) ! {
	p.target_actor_id = types.ActorUniqueID.decode(mut r)!
	p.target_runtime_id = types.ActorRuntimeID.decode(mut r)!
	p.position = [r.le_f32()!, r.le_f32()!, r.le_f32()!]!
	p.direction = r.read_varint32()!
	p.motif = r.read_string()!
}
