module packets

import serializer

pub struct BlockEntityDataPacket {
pub mut:
	x        i32
	y        u8
	z        i32
	namedtag []u8
}

pub fn (p &BlockEntityDataPacket) pid() u16 {
	return 0x37
}

pub fn (p &BlockEntityDataPacket) name() string {
	return 'BlockEntityDataPacket'
}

pub fn (p &BlockEntityDataPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &BlockEntityDataPacket) encode_payload(mut w serializer.Writer) {
	w.write_varint32(p.x)
	w.u8(p.y)
	w.write_varint32(p.z)
	w.write_raw(p.namedtag)
}

pub fn (mut p BlockEntityDataPacket) decode_payload(mut r serializer.Reader) ! {
	p.x = r.read_varint32()!
	p.y = r.u8()!
	p.z = r.read_varint32()!
	p.namedtag = r.read_raw(r.remaining())!
}
