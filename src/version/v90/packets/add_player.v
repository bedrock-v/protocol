module packets

import serializer
import version.v90.types

pub struct AddPlayerPacket {
pub mut:
	uuid     types.EraBUuid
	username string
	eid      i64
	x        f32
	y        f32
	z        f32
	speed_x  f32
	speed_y  f32
	speed_z  f32
	yaw      f32
	head_yaw f32
	pitch    f32
	item     types.EraBItem
	metadata types.EraBMetadata
}

pub fn (p &AddPlayerPacket) pid() u16 {
	return 0x0a
}

pub fn (p &AddPlayerPacket) name() string {
	return 'AddPlayerPacket'
}

pub fn (p &AddPlayerPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &AddPlayerPacket) encode_payload(mut w serializer.Writer) {
	p.uuid.encode(mut w)
	w.write_string(p.username)
	w.be_i64(p.eid)
	w.be_f32(p.x)
	w.be_f32(p.y)
	w.be_f32(p.z)
	w.be_f32(p.speed_x)
	w.be_f32(p.speed_y)
	w.be_f32(p.speed_z)
	w.be_f32(p.yaw)
	w.be_f32(p.head_yaw)
	w.be_f32(p.pitch)
	p.item.encode(mut w)
	p.metadata.encode(mut w)
}

pub fn (mut p AddPlayerPacket) decode_payload(mut r serializer.Reader) ! {
	p.uuid = types.EraBUuid.decode(mut r)!
	p.username = r.read_string()!
	p.eid = r.be_i64()!
	p.x = r.be_f32()!
	p.y = r.be_f32()!
	p.z = r.be_f32()!
	p.speed_x = r.be_f32()!
	p.speed_y = r.be_f32()!
	p.speed_z = r.be_f32()!
	p.yaw = r.be_f32()!
	p.head_yaw = r.be_f32()!
	p.pitch = r.be_f32()!
	p.item = types.EraBItem.decode(mut r)!
	p.metadata = types.EraBMetadata.decode(mut r)!
}
