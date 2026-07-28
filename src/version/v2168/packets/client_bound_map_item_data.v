module packets

import protocol.serializer
import protocol.version.v2168.types
import protocol.version.v662.types as types_662
import protocol.version.v944.types as types_944

pub struct ClientBoundMapItemDataPacket {
pub mut:
	map_id            types_662.ActorUniqueID
	dimension         i8
	is_locked         bool
	map_origin        types_944.NetworkBlockPosition
	creation_map_ids  ?[]types_662.ActorUniqueID
	scale             ?i8
	tracked_actor_ids ?[]types.MapItemTrackedActorUniqueID
	decorations       ?[]types.MapDecoration
	width             ?i32
	height            ?i32
	start_x           ?i32
	start_y           ?i32
	pixels            ?[]i32
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
	w.i8(p.dimension)
	w.bool(p.is_locked)
	p.map_origin.encode(mut w)
	if ids := p.creation_map_ids {
		w.bool(true)
		w.write_varuint32(u32(ids.len))
		for e in ids {
			e.encode(mut w)
		}
	} else {
		w.bool(false)
	}
	if v := p.scale {
		w.bool(true)
		w.i8(v)
	} else {
		w.bool(false)
	}
	if ids := p.tracked_actor_ids {
		w.bool(true)
		w.write_varuint32(u32(ids.len))
		for e in ids {
			e.encode(mut w)
		}
	} else {
		w.bool(false)
	}
	if decorations := p.decorations {
		w.bool(true)
		w.write_varuint32(u32(decorations.len))
		for e in decorations {
			e.encode(mut w)
		}
	} else {
		w.bool(false)
	}
	encode_opt_varint32(mut w, p.width)
	encode_opt_varint32(mut w, p.height)
	encode_opt_varint32(mut w, p.start_x)
	encode_opt_varint32(mut w, p.start_y)
	if pixels := p.pixels {
		w.bool(true)
		w.write_varuint32(u32(pixels.len))
		for e in pixels {
			w.le_i32(e)
		}
	} else {
		w.bool(false)
	}
}

pub fn (mut p ClientBoundMapItemDataPacket) decode_payload(mut r serializer.Reader) ! {
	p.map_id = types_662.ActorUniqueID.decode(mut r)!
	p.dimension = r.i8()!
	p.is_locked = r.bool()!
	p.map_origin = types_944.NetworkBlockPosition.decode(mut r)!
	if r.bool()! {
		count := int(r.read_varuint32()!)
		mut ids := []types_662.ActorUniqueID{cap: count}
		for _ in 0 .. count {
			ids << types_662.ActorUniqueID.decode(mut r)!
		}
		p.creation_map_ids = ids
	}
	if r.bool()! {
		p.scale = r.i8()!
	}
	if r.bool()! {
		count := int(r.read_varuint32()!)
		mut ids := []types.MapItemTrackedActorUniqueID{cap: count}
		for _ in 0 .. count {
			ids << types.MapItemTrackedActorUniqueID.decode(mut r)!
		}
		p.tracked_actor_ids = ids
	}
	if r.bool()! {
		count := int(r.read_varuint32()!)
		mut decorations := []types.MapDecoration{cap: count}
		for _ in 0 .. count {
			decorations << types.MapDecoration.decode(mut r)!
		}
		p.decorations = decorations
	}
	if r.bool()! {
		p.width = r.read_varint32()!
	}
	if r.bool()! {
		p.height = r.read_varint32()!
	}
	if r.bool()! {
		p.start_x = r.read_varint32()!
	}
	if r.bool()! {
		p.start_y = r.read_varint32()!
	}
	if r.bool()! {
		count := int(r.read_varuint32()!)
		mut pixels := []i32{cap: count}
		for _ in 0 .. count {
			pixels << r.le_i32()!
		}
		p.pixels = pixels
	}
}

fn encode_opt_varint32(mut w serializer.Writer, v ?i32) {
	if val := v {
		w.bool(true)
		w.write_varint32(val)
	} else {
		w.bool(false)
	}
}
