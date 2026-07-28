module packets

import protocol.serializer
import protocol.version.v137.types

pub struct SetSpawnPositionPacket {
pub mut:
	spawn_type   i32
	position     types.BlockPosition
	spawn_forced bool
}

pub fn (p &SetSpawnPositionPacket) pid() u16 {
	return 43
}

pub fn (p &SetSpawnPositionPacket) name() string {
	return 'SetSpawnPositionPacket'
}

pub fn (p &SetSpawnPositionPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &SetSpawnPositionPacket) encode_payload(mut w serializer.Writer) {
	w.write_varint32(p.spawn_type)
	p.position.encode(mut w)
	w.bool(p.spawn_forced)
}

pub fn (mut p SetSpawnPositionPacket) decode_payload(mut r serializer.Reader) ! {
	p.spawn_type = r.read_varint32()!
	p.position = types.BlockPosition.decode(mut r)!
	p.spawn_forced = r.bool()!
}
