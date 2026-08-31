module packets

import protocol.serializer
import protocol.version.v14.types as types_14

pub struct AddMobPacket {
pub mut:
	eid      i32
	typ      i32
	x        f32
	y        f32
	z        f32
	pitch    i8
	yaw      i8
	metadata types_14.OldMetadata
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
	w.be_f32(p.x)
	w.be_f32(p.y)
	w.be_f32(p.z)
	w.i8(p.pitch)
	w.i8(p.yaw)
	p.metadata.encode(mut w)
}

pub fn (mut p AddMobPacket) decode_payload(mut r serializer.Reader) ! {
	p.eid = r.be_i32()!
	p.typ = r.be_i32()!
	p.x = r.be_f32()!
	p.y = r.be_f32()!
	p.z = r.be_f32()!
	p.pitch = r.i8()!
	p.yaw = r.i8()!
	p.metadata = types_14.OldMetadata.decode(mut r)!
}
