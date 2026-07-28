module packets

import protocol.serializer
import protocol.version.v137.types

pub struct MapTrackedObject {
pub mut:
	type             i32
	entity_unique_id i64
	position         types.BlockPosition
}

pub struct MapItemDataDecoration {
pub mut:
	img      u8
	rot      u8
	x_offset u8
	y_offset u8
	label    string
	color    u32
}

pub struct ClientboundMapItemDataPacket {
pub mut:
	map_id           i64
	type             u32
	dimension_id     u8
	eids             []i64
	scale            u8
	tracked_entities []MapTrackedObject
	decorations      []MapItemDataDecoration
	width            i32
	height           i32
	x_offset         i32
	y_offset         i32
	colors           []u32
}

pub fn (p &ClientboundMapItemDataPacket) pid() u16 {
	return 67
}

pub fn (p &ClientboundMapItemDataPacket) name() string {
	return 'ClientboundMapItemDataPacket'
}

pub fn (p &ClientboundMapItemDataPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &ClientboundMapItemDataPacket) encode_payload(mut w serializer.Writer) {
	w.write_varint64(p.map_id)

	mut t := u32(0)
	if p.eids.len > 0 {
		t |= 0x08
	}
	if p.decorations.len > 0 {
		t |= 0x04
	}
	if p.colors.len > 0 {
		t |= 0x02
	}

	w.write_varuint32(t)
	w.u8(p.dimension_id)

	if t & 0x08 != 0 {
		w.write_varuint32(u32(p.eids.len))
		for eid in p.eids {
			w.write_varint64(eid)
		}
	}

	if t & (0x08 | 0x02 | 0x04) != 0 {
		w.u8(p.scale)
	}

	if t & 0x04 != 0 {
		w.write_varuint32(u32(p.tracked_entities.len))
		for o in p.tracked_entities {
			w.le_i32(o.type)
			if o.type == 1 {
				o.position.encode(mut w)
			} else if o.type == 0 {
				w.write_varint64(o.entity_unique_id)
			}
		}

		w.write_varuint32(u32(p.decorations.len))
		for d in p.decorations {
			w.u8(d.img)
			w.u8(d.rot)
			w.u8(d.x_offset)
			w.u8(d.y_offset)
			w.write_string(d.label)
			w.write_varuint32(d.color)
		}
	}

	if t & 0x02 != 0 {
		w.write_varint32(p.width)
		w.write_varint32(p.height)
		w.write_varint32(p.x_offset)
		w.write_varint32(p.y_offset)

		w.write_varuint32(u32(p.width * p.height))
		for c in p.colors {
			w.write_varuint32(c)
		}
	}
}

pub fn (mut p ClientboundMapItemDataPacket) decode_payload(mut r serializer.Reader) ! {
	p.map_id = r.read_varint64()!
	p.type = r.read_varuint32()!
	p.dimension_id = r.u8()!

	if p.type & 0x08 != 0 {
		count := int(r.read_varuint32()!)
		p.eids = []i64{cap: count}
		for _ in 0 .. count {
			p.eids << r.read_varint64()!
		}
	}

	if p.type & (0x08 | 0x04 | 0x02) != 0 {
		p.scale = r.u8()!
	}

	if p.type & 0x04 != 0 {
		object_count := int(r.read_varuint32()!)
		p.tracked_entities = []MapTrackedObject{cap: object_count}
		for _ in 0 .. object_count {
			mut o := MapTrackedObject{}
			o.type = r.le_i32()!
			if o.type == 1 {
				o.position = types.BlockPosition.decode(mut r)!
			} else if o.type == 0 {
				o.entity_unique_id = r.read_varint64()!
			} else {
				return error('unknown map object type')
			}
			p.tracked_entities << o
		}

		decoration_count := int(r.read_varuint32()!)
		p.decorations = []MapItemDataDecoration{cap: decoration_count}
		for _ in 0 .. decoration_count {
			mut d := MapItemDataDecoration{}
			d.img = r.u8()!
			d.rot = r.u8()!
			d.x_offset = r.u8()!
			d.y_offset = r.u8()!
			d.label = r.read_string()!
			d.color = r.read_varuint32()!
			p.decorations << d
		}
	}

	if p.type & 0x02 != 0 {
		p.width = r.read_varint32()!
		p.height = r.read_varint32()!
		p.x_offset = r.read_varint32()!
		p.y_offset = r.read_varint32()!

		color_count := int(r.read_varuint32()!)
		p.colors = []u32{cap: color_count}
		for _ in 0 .. color_count {
			p.colors << r.read_varuint32()!
		}
	}
}
