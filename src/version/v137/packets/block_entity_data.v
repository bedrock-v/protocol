module packets

import protocol.serializer
import protocol.version.v137.types

pub struct BlockEntityDataPacket {
pub mut:
	position types.BlockPosition
	namedtag []u8
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
	p.position.encode(mut w)
	w.write_raw(p.namedtag)
}

pub fn (mut p BlockEntityDataPacket) decode_payload(mut r serializer.Reader) ! {
	p.position = types.BlockPosition.decode(mut r)!
	p.namedtag = r.read_raw(r.remaining())!
}
