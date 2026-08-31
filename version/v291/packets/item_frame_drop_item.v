module packets

import protocol.serializer
import protocol.version.v291.types

pub struct ItemFrameDropItemPacket {
pub mut:
	block_position types.BlockPosition
}

pub fn (p &ItemFrameDropItemPacket) pid() u16 {
	return 71
}

pub fn (p &ItemFrameDropItemPacket) name() string {
	return 'ItemFrameDropItemPacket'
}

pub fn (p &ItemFrameDropItemPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &ItemFrameDropItemPacket) encode_payload(mut w serializer.Writer) {
	p.block_position.encode(mut w)
}

pub fn (mut p ItemFrameDropItemPacket) decode_payload(mut r serializer.Reader) ! {
	p.block_position = types.BlockPosition.decode(mut r)!
}
