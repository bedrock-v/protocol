module packets

import serializer
import version.v14.types

pub struct AddPlayerPacket {
pub mut:
	client_id i64
	username  string
	eid       i32
	x         f32
	y         f32
	z         f32
	pitch     i8
	yaw       i8
	unknown1  i16
	unknown2  i16
	metadata  types.OldMetadata
}

pub fn (p &AddPlayerPacket) pid() u16 {
	return 0x89
}

pub fn (p &AddPlayerPacket) name() string {
	return 'AddPlayerPacket'
}

pub fn (p &AddPlayerPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &AddPlayerPacket) encode_payload(mut w serializer.Writer) {
	w.be_i64(p.client_id)
	w.write_string_be(p.username)
	w.be_i32(p.eid)
	w.be_f32(p.x)
	w.be_f32(p.y)
	w.be_f32(p.z)
	w.i8(p.pitch)
	w.i8(p.yaw)
	w.be_i16(p.unknown1)
	w.be_i16(p.unknown2)
	p.metadata.encode(mut w)
}

pub fn (mut p AddPlayerPacket) decode_payload(mut r serializer.Reader) ! {
	p.client_id = r.be_i64()!
	p.username = r.read_string_be()!
	p.eid = r.be_i32()!
	p.x = r.be_f32()!
	p.y = r.be_f32()!
	p.z = r.be_f32()!
	p.pitch = r.i8()!
	p.yaw = r.i8()!
	p.unknown1 = r.be_i16()!
	p.unknown2 = r.be_i16()!
	p.metadata = types.OldMetadata.decode(mut r)!
}
