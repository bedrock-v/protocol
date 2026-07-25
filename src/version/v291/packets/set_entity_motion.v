module packets

import serializer
import version.v291.types

pub struct SetEntityMotionPacket {
pub mut:
	runtime_entity_id u64
	motion            types.Vector3f
}

pub fn (p &SetEntityMotionPacket) pid() u16 {
	return 40
}

pub fn (p &SetEntityMotionPacket) name() string {
	return 'SetEntityMotionPacket'
}

pub fn (p &SetEntityMotionPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &SetEntityMotionPacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint64(p.runtime_entity_id)
	p.motion.encode(mut w)
}

pub fn (mut p SetEntityMotionPacket) decode_payload(mut r serializer.Reader) ! {
	p.runtime_entity_id = r.read_varuint64()!
	p.motion = types.Vector3f.decode(mut r)!
}
