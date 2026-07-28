module packets

import protocol.serializer
import nbt
import protocol.version.v944.types

pub struct BlockActorDataPacket {
pub mut:
	block_position  types.NetworkBlockPosition
	actor_data_tags nbt.RootTag
}

pub fn (p &BlockActorDataPacket) pid() u16 {
	return 56
}

pub fn (p &BlockActorDataPacket) name() string {
	return 'BlockActorDataPacket'
}

pub fn (p &BlockActorDataPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &BlockActorDataPacket) encode_payload(mut w serializer.Writer) {
	p.block_position.encode(mut w)
	w.write_nbt_compound_root(p.actor_data_tags)
}

pub fn (mut p BlockActorDataPacket) decode_payload(mut r serializer.Reader) ! {
	p.block_position = types.NetworkBlockPosition.decode(mut r)!
	p.actor_data_tags = r.read_nbt_compound_root()!
}
