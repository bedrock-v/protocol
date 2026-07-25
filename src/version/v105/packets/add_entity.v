module packets

import serializer
import version.v105.types

pub struct AddEntityAttribute {
pub mut:
	name  string
	min   f32
	value f32
	max   f32
}

pub struct EntityLink {
pub mut:
	from i64
	to   i64
	type u8
}

pub struct AddEntityPacket {
pub mut:
	eid        i64
	type       u32
	x          f32
	y          f32
	z          f32
	speed_x    f32
	speed_y    f32
	speed_z    f32
	pitch      f32
	yaw        f32
	attributes []AddEntityAttribute
	metadata   types.EraBMetadata
	links      []EntityLink
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
	w.write_varint64(p.eid)
	w.write_varuint64(u64(p.eid))
	w.write_varuint32(p.type)
	w.le_f32(p.x)
	w.le_f32(p.y)
	w.le_f32(p.z)
	w.le_f32(p.speed_x)
	w.le_f32(p.speed_y)
	w.le_f32(p.speed_z)
	w.le_f32(p.pitch)
	w.le_f32(p.yaw)
	w.write_varuint32(u32(p.attributes.len))
	for a in p.attributes {
		w.write_string(a.name)
		w.le_f32(a.min)
		w.le_f32(a.value)
		w.le_f32(a.max)
	}
	p.metadata.encode(mut w)
	w.write_varuint32(u32(p.links.len))
	for l in p.links {
		w.write_varint64(l.from)
		w.write_varint64(l.to)
		w.u8(l.type)
	}
}

pub fn (mut p AddEntityPacket) decode_payload(mut r serializer.Reader) ! {
	p.eid = r.read_varint64()!
	_ = r.read_varuint64()!
	p.type = r.read_varuint32()!
	p.x = r.le_f32()!
	p.y = r.le_f32()!
	p.z = r.le_f32()!
	p.speed_x = r.le_f32()!
	p.speed_y = r.le_f32()!
	p.speed_z = r.le_f32()!
	p.pitch = r.le_f32()!
	p.yaw = r.le_f32()!
	na := int(r.read_varuint32()!)
	for _ in 0 .. na {
		p.attributes << AddEntityAttribute{
			name:  r.read_string()!
			min:   r.le_f32()!
			value: r.le_f32()!
			max:   r.le_f32()!
		}
	}
	p.metadata = types.EraBMetadata.decode(mut r)!
	nl := int(r.read_varuint32()!)
	for _ in 0 .. nl {
		p.links << EntityLink{
			from: r.read_varint64()!
			to:   r.read_varint64()!
			type: r.u8()!
		}
	}
}
