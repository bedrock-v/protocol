module packets

import protocol.serializer

pub struct MapDecoration {
pub mut:
	rot      i32
	img      i32
	x_offset u8
	y_offset u8
	label    string
	color    i32
}

pub struct ClientboundMapItemDataPacket {
pub mut:
	map_id      i64
	eids        []i64
	scale       u8
	decorations []MapDecoration
	width       i32
	height      i32
	x_offset    i32
	y_offset    i32
	colors      []u32
}

pub fn (p &ClientboundMapItemDataPacket) pid() u16 {
	return 0x43
}

pub fn (p &ClientboundMapItemDataPacket) name() string {
	return 'ClientboundMapItemDataPacket'
}

pub fn (p &ClientboundMapItemDataPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &ClientboundMapItemDataPacket) encode_payload(mut w serializer.Writer) {
	w.write_varint64(p.map_id)
	mut typ := u32(0)
	if p.eids.len > 0 {
		typ |= 0x08
	}
	if p.decorations.len > 0 {
		typ |= 0x04
	}
	if p.colors.len > 0 {
		typ |= 0x02
	}
	w.write_varuint32(typ)
	if (typ & 0x08) != 0 {
		w.write_varuint32(u32(p.eids.len))
		for e in p.eids {
			w.write_varint64(e)
		}
	}
	if (typ & (0x02 | 0x04)) != 0 {
		w.u8(p.scale)
	}
	if (typ & 0x04) != 0 {
		w.write_varuint32(u32(p.decorations.len))
		for d in p.decorations {
			w.write_varint32((d.rot & 0x0f) | (d.img << 4))
			w.u8(d.x_offset)
			w.u8(d.y_offset)
			w.write_string(d.label)
			w.le_i32(d.color)
		}
	}
	if (typ & 0x02) != 0 {
		w.write_varint32(p.width)
		w.write_varint32(p.height)
		w.write_varint32(p.x_offset)
		w.write_varint32(p.y_offset)
		for c in p.colors {
			w.write_varuint32(c)
		}
	}
}

pub fn (mut p ClientboundMapItemDataPacket) decode_payload(mut r serializer.Reader) ! {
	p.map_id = r.read_varint64()!
	typ := r.read_varuint32()!
	if (typ & 0x08) != 0 {
		n := int(r.read_varuint32()!)
		for _ in 0 .. n {
			p.eids << r.read_varint64()!
		}
	}
	if (typ & (0x02 | 0x04)) != 0 {
		p.scale = r.u8()!
	}
	if (typ & 0x04) != 0 {
		n := int(r.read_varuint32()!)
		for _ in 0 .. n {
			weird := r.read_varint32()!
			mut d := MapDecoration{
				rot: weird & 0x0f
				img: weird >> 4
			}
			d.x_offset = r.u8()!
			d.y_offset = r.u8()!
			d.label = r.read_string()!
			d.color = r.le_i32()!
			p.decorations << d
		}
	}
	if (typ & 0x02) != 0 {
		p.width = r.read_varint32()!
		p.height = r.read_varint32()!
		p.x_offset = r.read_varint32()!
		p.y_offset = r.read_varint32()!
		total := int(p.width) * int(p.height)
		for _ in 0 .. total {
			p.colors << r.read_varuint32()!
		}
	}
}
