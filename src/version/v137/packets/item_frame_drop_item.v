module packets

import serializer
import version.v137.types

pub struct ItemFrameDropItemPacket {
pub mut:
	position types.BlockPosition
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
	p.position.encode(mut w)
}

pub fn (mut p ItemFrameDropItemPacket) decode_payload(mut r serializer.Reader) ! {
	p.position = types.BlockPosition.decode(mut r)!
}
