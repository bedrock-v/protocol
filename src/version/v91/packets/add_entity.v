module packets

import serializer
import version.v91.types

pub struct EntityLink {
pub mut:
	from i32
	to   i32
	type u8
}

pub struct AddEntityPacket {
pub mut:
	eid       i32
	type      u32
	x         f32
	y         f32
	z         f32
	speed_x   f32
	speed_y   f32
	speed_z   f32
	yaw       f32
	pitch     f32
	modifiers u32
	metadata  types.EraBMetadata
	links     []EntityLink
}

pub fn (p &AddEntityPacket) pid() u16 {
	return 0x0e
}

pub fn (p &AddEntityPacket) name() string {
	return 'AddEntityPacket'
}

pub fn (p &AddEntityPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &AddEntityPacket) encode_payload(mut w serializer.Writer) {
	w.write_varint32(p.eid)
	w.write_varint32(p.eid)
	w.write_varuint32(p.type)
	w.le_f32(p.x)
	w.le_f32(p.y)
	w.le_f32(p.z)
	w.le_f32(p.speed_x)
	w.le_f32(p.speed_y)
	w.le_f32(p.speed_z)
	w.le_f32(p.yaw)
	w.le_f32(p.pitch)
	w.write_varuint32(p.modifiers)
	p.metadata.encode(mut w)
	w.write_varuint32(u32(p.links.len))
	for l in p.links {
		w.write_varint32(l.from)
		w.write_varint32(l.to)
		w.u8(l.type)
	}
}

pub fn (mut p AddEntityPacket) decode_payload(mut r serializer.Reader) ! {
	p.eid = r.read_varint32()!
	_ = r.read_varint32()!
	p.type = r.read_varuint32()!
	p.x = r.le_f32()!
	p.y = r.le_f32()!
	p.z = r.le_f32()!
	p.speed_x = r.le_f32()!
	p.speed_y = r.le_f32()!
	p.speed_z = r.le_f32()!
	p.yaw = r.le_f32()!
	p.pitch = r.le_f32()!
	p.modifiers = r.read_varuint32()!
	p.metadata = types.EraBMetadata.decode(mut r)!
	n := int(r.read_varuint32()!)
	for _ in 0 .. n {
		p.links << EntityLink{
			from: r.read_varint32()!
			to:   r.read_varint32()!
			type: r.u8()!
		}
	}
}
