module packets

import protocol.serializer
import protocol.version.v14.types as types_14

pub struct AddPlayerPacket {
pub mut:
	client_id i64
	username  string
	eid       i32
	x         f32
	y         f32
	z         f32
	metadata  types_14.OldMetadata
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
	p.metadata.encode(mut w)
}

pub fn (mut p AddPlayerPacket) decode_payload(mut r serializer.Reader) ! {
	p.client_id = r.be_i64()!
	p.username = r.read_string_be()!
	p.eid = r.be_i32()!
	p.x = r.be_f32()!
	p.y = r.be_f32()!
	p.z = r.be_f32()!
	p.metadata = types_14.OldMetadata.decode(mut r)!
}
