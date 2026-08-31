module packets

import protocol.serializer

pub struct TileEntityDataPacket {
pub mut:
	x        i32
	y        u8
	z        i32
	namedtag []u8
}

pub fn (p &TileEntityDataPacket) pid() u16 {
	return 0xad
}

pub fn (p &TileEntityDataPacket) name() string {
	return 'TileEntityDataPacket'
}

pub fn (p &TileEntityDataPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &TileEntityDataPacket) encode_payload(mut w serializer.Writer) {
	w.be_i32(p.x)
	w.u8(p.y)
	w.be_i32(p.z)
	w.write_raw(p.namedtag)
}

pub fn (mut p TileEntityDataPacket) decode_payload(mut r serializer.Reader) ! {
	p.x = r.be_i32()!
	p.y = r.u8()!
	p.z = r.be_i32()!
	p.namedtag = r.read_raw(r.remaining())!
}
