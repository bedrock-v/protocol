module packets

import protocol.serializer
import protocol.version.v113.types

pub struct EntityLink {
pub mut:
	from i64
	to   i64
	type u8
}

pub struct AddEntityPacket {
pub mut:
	entity_unique_id  i64
	entity_runtime_id u64
	type              u32
	x                 f32
	y                 f32
	z                 f32
	speed_x           f32
	speed_y           f32
	speed_z           f32
	pitch             f32
	yaw               f32
	attributes        []AttributeEntry
	metadata          types.EraBMetadata
	links             []EntityLink
}

pub fn (p &AddEntityPacket) pid() u16 {
	return 0x0d
}

pub fn (p &AddEntityPacket) name() string {
	return 'AddEntityPacket'
}

pub fn (p &AddEntityPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &AddEntityPacket) encode_payload(mut w serializer.Writer) {
	w.write_varint64(p.entity_unique_id)
	w.write_varuint64(p.entity_runtime_id)
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
		w.le_f32(a.min)
		w.le_f32(a.max)
		w.le_f32(a.current)
		w.le_f32(a.default)
		w.write_string(a.name)
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
	p.entity_unique_id = r.read_varint64()!
	p.entity_runtime_id = r.read_varuint64()!
	p.type = r.read_varuint32()!
	p.x = r.le_f32()!
	p.y = r.le_f32()!
	p.z = r.le_f32()!
	p.speed_x = r.le_f32()!
	p.speed_y = r.le_f32()!
	p.speed_z = r.le_f32()!
	p.pitch = r.le_f32()!
	p.yaw = r.le_f32()!
	an := int(r.read_varuint32()!)
	for _ in 0 .. an {
		p.attributes << AttributeEntry{
			min:     r.le_f32()!
			max:     r.le_f32()!
			current: r.le_f32()!
			default: r.le_f32()!
			name:    r.read_string()!
		}
	}
	p.metadata = types.EraBMetadata.decode(mut r)!
	ln := int(r.read_varuint32()!)
	for _ in 0 .. ln {
		p.links << EntityLink{
			from: r.read_varint64()!
			to:   r.read_varint64()!
			type: r.u8()!
		}
	}
}
