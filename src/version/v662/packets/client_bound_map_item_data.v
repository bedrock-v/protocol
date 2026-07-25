module packets

import serializer
import version.v662.types

pub struct MapPixelsEntry {
pub mut:
	pixel u32
}

pub struct MapTypeInvalid {}

pub struct MapTypeTextureUpdate {
pub mut:
	texture_width    i32
	texture_height   i32
	x_tex_coordinate i32
	y_tex_coordinate i32
	pixels           []MapPixelsEntry
}

pub struct MapTypeDecorationUpdate {
pub mut:
	actor_ids       []types.MapItemTrackedActorUniqueID
	decoration_list []types.MapDecoration
}

pub struct MapTypeCreation {
pub mut:
	map_id_list []types.ActorUniqueID
}

pub type ClientBoundMapType = MapTypeCreation
	| MapTypeDecorationUpdate
	| MapTypeInvalid
	| MapTypeTextureUpdate

pub fn (t ClientBoundMapType) id() u32 {
	return match t {
		MapTypeInvalid { u32(0x0) }
		MapTypeTextureUpdate { u32(0x2) }
		MapTypeDecorationUpdate { u32(0x4) }
		MapTypeCreation { u32(0x8) }
	}
}

pub fn (t ClientBoundMapType) encode_payload(mut w serializer.Writer) {
	match t {
		MapTypeTextureUpdate {
			w.write_varint32(t.texture_width)
			w.write_varint32(t.texture_height)
			w.write_varint32(t.x_tex_coordinate)
			w.write_varint32(t.y_tex_coordinate)
			w.write_varuint32(u32(t.pixels.len))
			for e in t.pixels {
				w.write_varuint32(e.pixel)
			}
		}
		MapTypeDecorationUpdate {
			w.write_varuint32(u32(t.actor_ids.len))
			for e in t.actor_ids {
				e.encode(mut w)
			}
			w.write_varuint32(u32(t.decoration_list.len))
			for e in t.decoration_list {
				e.encode(mut w)
			}
		}
		MapTypeCreation {
			w.write_varuint32(u32(t.map_id_list.len))
			for e in t.map_id_list {
				e.encode(mut w)
			}
		}
		MapTypeInvalid {}
	}
}

pub fn ClientBoundMapType.decode_payload(id u32, mut r serializer.Reader) !ClientBoundMapType {
	match id {
		0x0 {
			return MapTypeInvalid{}
		}
		0x2 {
			mut t := MapTypeTextureUpdate{}
			t.texture_width = r.read_varint32()!
			t.texture_height = r.read_varint32()!
			t.x_tex_coordinate = r.read_varint32()!
			t.y_tex_coordinate = r.read_varint32()!
			count := int(r.read_varuint32()!)
			t.pixels = []MapPixelsEntry{cap: count}
			for _ in 0 .. count {
				t.pixels << MapPixelsEntry{
					pixel: r.read_varuint32()!
				}
			}
			return t
		}
		0x4 {
			mut t := MapTypeDecorationUpdate{}
			ac := int(r.read_varuint32()!)
			t.actor_ids = []types.MapItemTrackedActorUniqueID{cap: ac}
			for _ in 0 .. ac {
				t.actor_ids << types.MapItemTrackedActorUniqueID.decode(mut r)!
			}
			dc := int(r.read_varuint32()!)
			t.decoration_list = []types.MapDecoration{cap: dc}
			for _ in 0 .. dc {
				t.decoration_list << types.MapDecoration.decode(mut r)!
			}
			return t
		}
		0x8 {
			mut t := MapTypeCreation{}
			mc := int(r.read_varuint32()!)
			t.map_id_list = []types.ActorUniqueID{cap: mc}
			for _ in 0 .. mc {
				t.map_id_list << types.ActorUniqueID.decode(mut r)!
			}
			return t
		}
		else {
			return error('invalid ClientBoundMapType ${id}')
		}
	}
}

pub struct ClientBoundMapItemDataPacket {
pub mut:
	map_id     types.ActorUniqueID
	type_flags ClientBoundMapType = MapTypeInvalid{}
	dimension  i8
	is_locked  bool
	map_origin types.BlockPos
}

pub fn (p &ClientBoundMapItemDataPacket) pid() u16 { return 67 }

pub fn (p &ClientBoundMapItemDataPacket) name() string { return 'ClientBoundMapItemDataPacket' }

pub fn (p &ClientBoundMapItemDataPacket) can_be_sent_before_login() bool { return false }

pub fn (p &ClientBoundMapItemDataPacket) encode_payload(mut w serializer.Writer) {
	p.map_id.encode(mut w)
	w.write_varuint32(p.type_flags.id())
	w.i8(p.dimension)
	w.bool(p.is_locked)
	p.map_origin.encode(mut w)
	p.type_flags.encode_payload(mut w)
}

pub fn (mut p ClientBoundMapItemDataPacket) decode_payload(mut r serializer.Reader) ! {
	p.map_id = types.ActorUniqueID.decode(mut r)!
	type_id := r.read_varuint32()!
	p.dimension = r.i8()!
	p.is_locked = r.bool()!
	p.map_origin = types.BlockPos.decode(mut r)!
	p.type_flags = ClientBoundMapType.decode_payload(type_id, mut r)!
}
