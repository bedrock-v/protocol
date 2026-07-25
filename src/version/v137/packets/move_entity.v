module packets

import serializer
import version.v137.types

pub struct MoveEntityPacket {
pub mut:
	entity_runtime_id u64
	position          types.Vector3f
	pitch             u8
	head_yaw          u8
	yaw               u8
	on_ground         bool
	teleported        bool
}

pub fn (p &MoveEntityPacket) pid() u16 {
	return 18
}

pub fn (p &MoveEntityPacket) name() string {
	return 'MoveEntityPacket'
}

pub fn (p &MoveEntityPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &MoveEntityPacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint64(p.entity_runtime_id)
	p.position.encode(mut w)
	w.u8(p.pitch)
	w.u8(p.head_yaw)
	w.u8(p.yaw)
	w.bool(p.on_ground)
	w.bool(p.teleported)
}

pub fn (mut p MoveEntityPacket) decode_payload(mut r serializer.Reader) ! {
	p.entity_runtime_id = r.read_varuint64()!
	p.position = types.Vector3f.decode(mut r)!
	p.pitch = r.u8()!
	p.head_yaw = r.u8()!
	p.yaw = r.u8()!
	p.on_ground = r.bool()!
	p.teleported = r.bool()!
}
