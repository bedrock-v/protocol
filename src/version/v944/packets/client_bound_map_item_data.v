module packets

import protocol.serializer
import protocol.version.v662.types as types_662
import protocol.version.v944.types

pub struct MapPixelsEntry {
pub mut:
	pixel u32
}

pub const map_update_flag_texture = u32(0x2)
pub const map_update_flag_decoration = u32(0x4)
pub const map_update_flag_initialisation = u32(0x8)

pub struct ClientBoundMapItemDataPacket {
pub mut:
	map_id           types_662.ActorUniqueID
	update_flags     u32
	dimension        u8
	is_locked        bool
	map_origin       types_662.BlockPos
	scale            u8
	maps_included_in []types_662.ActorUniqueID
	tracked_objects  []types.MapItemTrackedActorUniqueID
	decorations      []types_662.MapDecoration
	width            i32
	height           i32
	x_offset         i32
	y_offset         i32
	pixels           []MapPixelsEntry
}

pub fn (p &ClientBoundMapItemDataPacket) pid() u16 {
	return 67
}

pub fn (p &ClientBoundMapItemDataPacket) name() string {
	return 'ClientBoundMapItemDataPacket'
}

pub fn (p &ClientBoundMapItemDataPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &ClientBoundMapItemDataPacket) encode_payload(mut w serializer.Writer) {
	p.map_id.encode(mut w)
	w.write_varuint32(p.update_flags)
	w.u8(p.dimension)
	w.bool(p.is_locked)
	p.map_origin.encode(mut w)
	if p.update_flags & map_update_flag_initialisation != 0 {
		w.write_varuint32(u32(p.maps_included_in.len))
		for e in p.maps_included_in {
			e.encode(mut w)
		}
	}
	if p.update_flags & (map_update_flag_initialisation | map_update_flag_decoration | map_update_flag_texture) != 0 {
		w.u8(p.scale)
	}
	if p.update_flags & map_update_flag_decoration != 0 {
		w.write_varuint32(u32(p.tracked_objects.len))
		for e in p.tracked_objects {
			e.encode(mut w)
		}
		w.write_varuint32(u32(p.decorations.len))
		for e in p.decorations {
			e.encode(mut w)
		}
	}
	if p.update_flags & map_update_flag_texture != 0 {
		w.write_varint32(p.width)
		w.write_varint32(p.height)
		w.write_varint32(p.x_offset)
		w.write_varint32(p.y_offset)
		w.write_varuint32(u32(p.pixels.len))
		for e in p.pixels {
			w.write_varuint32(e.pixel)
		}
	}
}

pub fn (mut p ClientBoundMapItemDataPacket) decode_payload(mut r serializer.Reader) ! {
	p.map_id = types_662.ActorUniqueID.decode(mut r)!
	p.update_flags = r.read_varuint32()!
	p.dimension = r.u8()!
	p.is_locked = r.bool()!
	p.map_origin = types_662.BlockPos.decode(mut r)!
	if p.update_flags & map_update_flag_initialisation != 0 {
		count := int(r.read_varuint32()!)
		p.maps_included_in = []types_662.ActorUniqueID{cap: count}
		for _ in 0 .. count {
			p.maps_included_in << types_662.ActorUniqueID.decode(mut r)!
		}
	}
	if p.update_flags & (map_update_flag_initialisation | map_update_flag_decoration | map_update_flag_texture) != 0 {
		p.scale = r.u8()!
	}
	if p.update_flags & map_update_flag_decoration != 0 {
		tracked_count := int(r.read_varuint32()!)
		p.tracked_objects = []types.MapItemTrackedActorUniqueID{cap: tracked_count}
		for _ in 0 .. tracked_count {
			p.tracked_objects << types.MapItemTrackedActorUniqueID.decode(mut r)!
		}
		decoration_count := int(r.read_varuint32()!)
		p.decorations = []types_662.MapDecoration{cap: decoration_count}
		for _ in 0 .. decoration_count {
			p.decorations << types_662.MapDecoration.decode(mut r)!
		}
	}
	if p.update_flags & map_update_flag_texture != 0 {
		p.width = r.read_varint32()!
		p.height = r.read_varint32()!
		p.x_offset = r.read_varint32()!
		p.y_offset = r.read_varint32()!
		pixel_count := int(r.read_varuint32()!)
		p.pixels = []MapPixelsEntry{cap: pixel_count}
		for _ in 0 .. pixel_count {
			p.pixels << MapPixelsEntry{
				pixel: r.read_varuint32()!
			}
		}
	}
}
