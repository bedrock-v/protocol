module packets

import protocol.serializer

pub struct AddHangingEntityPacket {
pub mut:
	eid     i64
	x       i32
	y       u32
	z       i32
	unknown i32
}

pub fn (p &AddHangingEntityPacket) pid() u16 {
	return 0x11
}

pub fn (p &AddHangingEntityPacket) name() string {
	return 'AddHangingEntityPacket'
}

pub fn (p &AddHangingEntityPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &AddHangingEntityPacket) encode_payload(mut w serializer.Writer) {
	w.write_varint64(p.eid)
	w.write_varuint64(u64(p.eid))
	w.write_varint32(p.x)
	w.write_varuint32(p.y)
	w.write_varint32(p.z)
	w.write_varint32(p.unknown)
}

pub fn (mut p AddHangingEntityPacket) decode_payload(mut r serializer.Reader) ! {
	p.eid = r.read_varint64()!
	_ = r.read_varuint64()!
	p.x = r.read_varint32()!
	p.y = r.read_varuint32()!
	p.z = r.read_varint32()!
	p.unknown = r.read_varint32()!
}
