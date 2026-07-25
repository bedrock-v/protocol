module packets

import serializer
import version.v291.types

pub struct ClientboundMapItemDataPacket {
pub mut:
	unique_map_id      i64
	dimension_id       u8
	locked             bool
	scale              u8
	tracked_entity_ids []i64
	tracked_objects    []types.MapTrackedObject
	decorations        []types.MapDecoration
	width              i32
	height             i32
	x_offset           i32
	y_offset           i32
	colors             []u32
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
	w.write_varint64(p.unique_map_id)
	mut update_type := u32(0)
	if p.colors.len > 0 {
		update_type |= 0x2
	}
	if p.decorations.len > 0 || p.tracked_objects.len > 0 {
		update_type |= 0x4
	}
	if p.tracked_entity_ids.len > 0 {
		update_type |= 0x8
	}
	w.write_varuint32(update_type)
	w.u8(p.dimension_id)
	w.bool(p.locked)
	if update_type & 0x8 != 0 {
		w.write_varuint32(u32(p.tracked_entity_ids.len))
		for entity_id in p.tracked_entity_ids {
			w.write_varint64(entity_id)
		}
	}
	if update_type & 0xe != 0 {
		w.u8(p.scale)
	}
	if update_type & 0x4 != 0 {
		w.write_varuint32(u32(p.tracked_objects.len))
		for object in p.tracked_objects {
			object.encode(mut w)
		}
		w.write_varuint32(u32(p.decorations.len))
		for decoration in p.decorations {
			decoration.encode(mut w)
		}
	}
	if update_type & 0x2 != 0 {
		w.write_varint32(p.width)
		w.write_varint32(p.height)
		w.write_varint32(p.x_offset)
		w.write_varint32(p.y_offset)
		w.write_varuint32(u32(p.colors.len))
		for color in p.colors {
			w.write_varuint32(color)
		}
	}
}

pub fn (mut p ClientboundMapItemDataPacket) decode_payload(mut r serializer.Reader) ! {
	p.unique_map_id = r.read_varint64()!
	update_type := r.read_varuint32()!
	p.dimension_id = r.u8()!
	p.locked = r.bool()!
	if update_type & 0x8 != 0 {
		entity_count := int(r.read_varuint32()!)
		p.tracked_entity_ids = []i64{cap: entity_count}
		for _ in 0 .. entity_count {
			p.tracked_entity_ids << r.read_varint64()!
		}
	}
	if update_type & 0xe != 0 {
		p.scale = r.u8()!
	}
	if update_type & 0x4 != 0 {
		object_count := int(r.read_varuint32()!)
		p.tracked_objects = []types.MapTrackedObject{cap: object_count}
		for _ in 0 .. object_count {
			p.tracked_objects << types.MapTrackedObject.decode(mut r)!
		}
		decoration_count := int(r.read_varuint32()!)
		p.decorations = []types.MapDecoration{cap: decoration_count}
		for _ in 0 .. decoration_count {
			p.decorations << types.MapDecoration.decode(mut r)!
		}
	}
	if update_type & 0x2 != 0 {
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
