module packets

import serializer
import version.v14.types

pub struct AddMobPacket {
pub mut:
	eid      i32
	typ      i32
	x        i32
	y        i32
	z        i32
	yaw      i8
	pitch    i8
	metadata types.OldMetadata
}

pub fn (p &AddMobPacket) pid() u16 {
	return 0x88
}

pub fn (p &AddMobPacket) name() string {
	return 'AddMobPacket'
}

pub fn (p &AddMobPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &AddMobPacket) encode_payload(mut w serializer.Writer) {
	w.be_i32(p.eid)
	w.be_i32(p.typ)
	w.be_i32(p.x)
	w.be_i32(p.y)
	w.be_i32(p.z)
	w.i8(p.yaw)
	w.i8(p.pitch)
	p.metadata.encode(mut w)
}

pub fn (mut p AddMobPacket) decode_payload(mut r serializer.Reader) ! {
	p.eid = r.be_i32()!
	p.typ = r.be_i32()!
	p.x = r.be_i32()!
	p.y = r.be_i32()!
	p.z = r.be_i32()!
	p.yaw = r.i8()!
	p.pitch = r.i8()!
	p.metadata = types.OldMetadata.decode(mut r)!
}
