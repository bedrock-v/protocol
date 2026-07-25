module packets

import serializer
import version.v14.types

pub struct EntityLink {
pub mut:
	from i64
	to   i64
	typ  u8
}

pub struct AddEntityPacket {
pub mut:
	eid      i64
	typ      i32
	x        f32
	y        f32
	z        f32
	speed_x  f32
	speed_y  f32
	speed_z  f32
	yaw      f32
	pitch    f32
	metadata types.OldMetadata
	links    []EntityLink
}

pub fn (p &AddEntityPacket) pid() u16 {
	return 0x8a
}

pub fn (p &AddEntityPacket) name() string {
	return 'AddEntityPacket'
}

pub fn (p &AddEntityPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &AddEntityPacket) encode_payload(mut w serializer.Writer) {
	w.be_i64(p.eid)
	w.be_i32(p.typ)
	w.be_f32(p.x)
	w.be_f32(p.y)
	w.be_f32(p.z)
	w.be_f32(p.speed_x)
	w.be_f32(p.speed_y)
	w.be_f32(p.speed_z)
	w.be_f32(p.yaw)
	w.be_f32(p.pitch)
	p.metadata.encode(mut w)
	w.be_i16(i16(p.links.len))
	for link in p.links {
		w.be_i64(link.from)
		w.be_i64(link.to)
		w.u8(link.typ)
	}
}

pub fn (mut p AddEntityPacket) decode_payload(mut r serializer.Reader) ! {
	p.eid = r.be_i64()!
	p.typ = r.be_i32()!
	p.x = r.be_f32()!
	p.y = r.be_f32()!
	p.z = r.be_f32()!
	p.speed_x = r.be_f32()!
	p.speed_y = r.be_f32()!
	p.speed_z = r.be_f32()!
	p.yaw = r.be_f32()!
	p.pitch = r.be_f32()!
	p.metadata = types.OldMetadata.decode(mut r)!
	count := int(r.be_u16()!)
	p.links = []EntityLink{cap: count}
	for _ in 0 .. count {
		p.links << EntityLink{
			from: r.be_i64()!
			to:   r.be_i64()!
			typ:  r.u8()!
		}
	}
}
