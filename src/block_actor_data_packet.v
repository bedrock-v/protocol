module protocol

import serializer
import types
import nbt

pub struct BlockActorDataPacket {
pub mut:
	block_position types.BlockPosition
	nbt            nbt.RootTag
}

pub fn (p &BlockActorDataPacket) pid() u16 {
	return block_actor_data_packet
}

pub fn (p &BlockActorDataPacket) name() string {
	return 'BlockActorDataPacket'
}

pub fn (p &BlockActorDataPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p BlockActorDataPacket) decode_payload(mut r serializer.Reader) ! {
	p.block_position = r.read_block_position()!
	p.nbt = r.read_nbt_compound_root()!
}

pub fn (p &BlockActorDataPacket) encode_payload(mut w serializer.Writer) {
	w.write_block_position(p.block_position)
	w.write_nbt_compound_root(p.nbt)
}
