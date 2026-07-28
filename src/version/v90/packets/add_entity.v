module packets

import protocol.serializer
import protocol.version.v90.types

pub struct EntityLink {
pub mut:
	from i64
	to   i64
	type u8
}

pub struct AddEntityPacket {
pub mut:
	eid       i64
	type      i32
	x         f32
	y         f32
	z         f32
	speed_x   f32
	speed_y   f32
	speed_z   f32
	yaw       f32
	pitch     f32
	modifiers i32
	metadata  types.EraBMetadata
	links     []EntityLink
}

pub fn (p &AddEntityPacket) pid() u16 {
	return 0x0b
}

pub fn (p &AddEntityPacket) name() string {
	return 'AddEntityPacket'
}

pub fn (p &AddEntityPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &AddEntityPacket) encode_payload(mut w serializer.Writer) {
	w.be_i64(p.eid)
	w.be_i32(p.type)
	w.be_f32(p.x)
	w.be_f32(p.y)
	w.be_f32(p.z)
	w.be_f32(p.speed_x)
	w.be_f32(p.speed_y)
	w.be_f32(p.speed_z)
	w.be_f32(p.yaw)
	w.be_f32(p.pitch)
	w.be_i32(p.modifiers)
	p.metadata.encode(mut w)
	w.be_i16(i16(p.links.len))
	for l in p.links {
		w.be_i64(l.from)
		w.be_i64(l.to)
		w.u8(l.type)
	}
}

pub fn (mut p AddEntityPacket) decode_payload(mut r serializer.Reader) ! {
	p.eid = r.be_i64()!
	p.type = r.be_i32()!
	p.x = r.be_f32()!
	p.y = r.be_f32()!
	p.z = r.be_f32()!
	p.speed_x = r.be_f32()!
	p.speed_y = r.be_f32()!
	p.speed_z = r.be_f32()!
	p.yaw = r.be_f32()!
	p.pitch = r.be_f32()!
	p.modifiers = r.be_i32()!
	p.metadata = types.EraBMetadata.decode(mut r)!
	n := int(r.be_u16()!)
	for _ in 0 .. n {
		p.links << EntityLink{
			from: r.be_i64()!
			to:   r.be_i64()!
			type: r.u8()!
		}
	}
}
