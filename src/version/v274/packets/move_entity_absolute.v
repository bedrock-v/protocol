module packets

import protocol.serializer
import protocol.version.v137.types

pub struct MoveEntityAbsolutePacket {
pub mut:
	entity_runtime_id u64
	flags             u8
	position          types.Vector3f
	x_rot             u8
	y_rot             u8
	z_rot             u8
}

pub fn (p &MoveEntityAbsolutePacket) pid() u16 {
	return 18
}

pub fn (p &MoveEntityAbsolutePacket) name() string {
	return 'MoveEntityAbsolutePacket'
}

pub fn (p &MoveEntityAbsolutePacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &MoveEntityAbsolutePacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint64(p.entity_runtime_id)
	w.u8(p.flags)
	p.position.encode(mut w)
	w.u8(p.x_rot)
	w.u8(p.y_rot)
	w.u8(p.z_rot)
}

pub fn (mut p MoveEntityAbsolutePacket) decode_payload(mut r serializer.Reader) ! {
	p.entity_runtime_id = r.read_varuint64()!
	p.flags = r.u8()!
	p.position = types.Vector3f.decode(mut r)!
	p.x_rot = r.u8()!
	p.y_rot = r.u8()!
	p.z_rot = r.u8()!
}
