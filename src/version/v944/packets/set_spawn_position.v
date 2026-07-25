module packets

import serializer
import version.v662.enums
import version.v944.types

pub struct SetSpawnPositionPacket {
pub mut:
	spawn_position_type enums.SpawnPositionType
	block_position      types.NetworkBlockPosition
	dimension_type      i32
	spawn_block_pos     types.NetworkBlockPosition
}

pub fn (p &SetSpawnPositionPacket) pid() u16 { return 43 }

pub fn (p &SetSpawnPositionPacket) name() string { return 'SetSpawnPositionPacket' }

pub fn (p &SetSpawnPositionPacket) can_be_sent_before_login() bool { return false }

pub fn (p &SetSpawnPositionPacket) encode_payload(mut w serializer.Writer) {
	p.spawn_position_type.encode(mut w)
	p.block_position.encode(mut w)
	w.write_varint32(p.dimension_type)
	p.spawn_block_pos.encode(mut w)
}

pub fn (mut p SetSpawnPositionPacket) decode_payload(mut r serializer.Reader) ! {
	p.spawn_position_type = enums.SpawnPositionType.decode(mut r)!
	p.block_position = types.NetworkBlockPosition.decode(mut r)!
	p.dimension_type = r.read_varint32()!
	p.spawn_block_pos = types.NetworkBlockPosition.decode(mut r)!
}
