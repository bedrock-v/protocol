module src

import src.serializer
import src.types

pub const map_update_flag_texture = u32(0x02)
pub const map_update_flag_decoration = u32(0x04)
pub const map_update_flag_initialisation = u32(0x08)

pub const map_object_type_entity = 0
pub const map_object_type_block = 1

pub struct MapTrackedObject {
pub mut:
	type             int
	entity_unique_id i64
	block_position   types.BlockPosition
}

pub struct MapDecoration {
pub mut:
	type     u8
	rotation u8
	x        u8
	y        u8
	label    string
	colour   u32
}

pub struct ClientboundMapItemDataPacket {
pub mut:
	map_id          i64
	update_flags    u32
	dimension       u8
	locked_map      bool
	origin          types.BlockPosition
	scale           u8
	maps_included_in []i64
	tracked_objects []MapTrackedObject
	decorations     []MapDecoration
	width           int
	height          int
	x_offset        int
	y_offset        int
	pixels          []u32
}

pub fn (p &ClientboundMapItemDataPacket) pid() u16 {
	return clientbound_map_item_data_packet
}

pub fn (p &ClientboundMapItemDataPacket) name() string {
	return 'ClientboundMapItemDataPacket'
}

pub fn (p &ClientboundMapItemDataPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p ClientboundMapItemDataPacket) decode_payload(mut r serializer.Reader) ! {
	p.map_id = r.read_varint64()!
	p.update_flags = r.read_varuint32()!
	p.dimension = r.u8()!
	p.locked_map = r.bool()!
	p.origin = r.read_block_position()!

	if p.update_flags & map_update_flag_initialisation != 0 {
		count := r.read_varuint32()!
		p.maps_included_in = []i64{}
		for _ in 0 .. count {
			p.maps_included_in << r.read_varint64()!
		}
	}
	if p.update_flags & (map_update_flag_initialisation | map_update_flag_decoration | map_update_flag_texture) != 0 {
		p.scale = r.u8()!
	}
	if p.update_flags & map_update_flag_decoration != 0 {
		obj_count := r.read_varuint32()!
		p.tracked_objects = []MapTrackedObject{}
		for _ in 0 .. obj_count {
			mut o := MapTrackedObject{
				type: r.le_i32()!
			}
			match o.type {
				map_object_type_entity { o.entity_unique_id = r.read_varint64()! }
				map_object_type_block { o.block_position = r.read_block_position()! }
				else {}
			}
			p.tracked_objects << o
		}
		dec_count := r.read_varuint32()!
		p.decorations = []MapDecoration{}
		for _ in 0 .. dec_count {
			p.decorations << MapDecoration{
				type:     r.u8()!
				rotation: r.u8()!
				x:        r.u8()!
				y:        r.u8()!
				label:    r.read_string()!
				colour:   r.read_varuint32()!
			}
		}
	}
	if p.update_flags & map_update_flag_texture != 0 {
		p.width = r.read_varint32()!
		p.height = r.read_varint32()!
		p.x_offset = r.read_varint32()!
		p.y_offset = r.read_varint32()!
		pixel_count := r.read_varuint32()!
		p.pixels = []u32{}
		for _ in 0 .. pixel_count {
			p.pixels << r.read_varuint32()!
		}
	}
}

pub fn (p &ClientboundMapItemDataPacket) encode_payload(mut w serializer.Writer) {
	w.write_varint64(p.map_id)
	w.write_varuint32(p.update_flags)
	w.u8(p.dimension)
	w.bool(p.locked_map)
	w.write_block_position(p.origin)

	if p.update_flags & map_update_flag_initialisation != 0 {
		w.write_varuint32(u32(p.maps_included_in.len))
		for m in p.maps_included_in {
			w.write_varint64(m)
		}
	}
	if p.update_flags & (map_update_flag_initialisation | map_update_flag_decoration | map_update_flag_texture) != 0 {
		w.u8(p.scale)
	}
	if p.update_flags & map_update_flag_decoration != 0 {
		w.write_varuint32(u32(p.tracked_objects.len))
		for o in p.tracked_objects {
			w.le_i32(o.type)
			match o.type {
				map_object_type_entity { w.write_varint64(o.entity_unique_id) }
				map_object_type_block { w.write_block_position(o.block_position) }
				else {}
			}
		}
		w.write_varuint32(u32(p.decorations.len))
		for d in p.decorations {
			w.u8(d.type)
			w.u8(d.rotation)
			w.u8(d.x)
			w.u8(d.y)
			w.write_string(d.label)
			w.write_varuint32(d.colour)
		}
	}
	if p.update_flags & map_update_flag_texture != 0 {
		w.write_varint32(p.width)
		w.write_varint32(p.height)
		w.write_varint32(p.x_offset)
		w.write_varint32(p.y_offset)
		w.write_varuint32(u32(p.pixels.len))
		for px in p.pixels {
			w.write_varuint32(px)
		}
	}
}
