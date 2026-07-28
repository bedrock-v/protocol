module packets

import protocol.serializer
import nbt
import protocol.version.v291.types

pub struct BlockEntityDataPacket {
pub mut:
	block_position types.BlockPosition
	data           nbt.RootTag
}

pub fn (p &BlockEntityDataPacket) pid() u16 {
	return 56
}

pub fn (p &BlockEntityDataPacket) name() string {
	return 'BlockEntityDataPacket'
}

pub fn (p &BlockEntityDataPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &BlockEntityDataPacket) encode_payload(mut w serializer.Writer) {
	p.block_position.encode(mut w)
	w.write_nbt_compound_root(p.data)
}

pub fn (mut p BlockEntityDataPacket) decode_payload(mut r serializer.Reader) ! {
	p.block_position = types.BlockPosition.decode(mut r)!
	p.data = r.read_nbt_compound_root()!
}
