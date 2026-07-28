module packets

import protocol.serializer

pub struct ItemFrameDropItemPacket {
pub mut:
	x i32
	y u32
	z i32
}

pub fn (p &ItemFrameDropItemPacket) pid() u16 {
	return 0x47
}

pub fn (p &ItemFrameDropItemPacket) name() string {
	return 'ItemFrameDropItemPacket'
}

pub fn (p &ItemFrameDropItemPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &ItemFrameDropItemPacket) encode_payload(mut w serializer.Writer) {
	w.write_varint32(p.x)
	w.write_varuint32(p.y)
	w.write_varint32(p.z)
}

pub fn (mut p ItemFrameDropItemPacket) decode_payload(mut r serializer.Reader) ! {
	p.x = r.read_varint32()!
	p.y = r.read_varuint32()!
	p.z = r.read_varint32()!
}
