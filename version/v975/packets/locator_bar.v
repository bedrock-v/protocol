module packets

import protocol.serializer
import protocol.version.v662.types as types_662

pub enum LocatorBarPayloadAction as u8 {
	@none  = 0
	add    = 1
	remove = 2
	update = 3
}

pub fn (e LocatorBarPayloadAction) encode(mut w serializer.Writer) {
	w.u8(u8(e))
}

pub fn LocatorBarPayloadAction.decode(mut r serializer.Reader) !LocatorBarPayloadAction {
	return unsafe { LocatorBarPayloadAction(r.u8()!) }
}

pub struct LocatorBarWaypointWorldPosition {
pub mut:
	position  [3]f32
	dimension i32
}

pub fn (t LocatorBarWaypointWorldPosition) encode(mut w serializer.Writer) {
	w.le_f32(t.position[0])
	w.le_f32(t.position[1])
	w.le_f32(t.position[2])
	w.write_varint32(t.dimension)
}

pub fn LocatorBarWaypointWorldPosition.decode(mut r serializer.Reader) !LocatorBarWaypointWorldPosition {
	return LocatorBarWaypointWorldPosition{
		position:  [r.le_f32()!, r.le_f32()!, r.le_f32()!]!
		dimension: r.read_varint32()!
	}
}

pub struct LocatorBarWaypoint {
pub mut:
	update_flag      u32
	visible          ?bool
	world_position   ?LocatorBarWaypointWorldPosition
	texture_path     string
	icon_size        [2]f32
	color            ?i32
	client_authority ?bool
	entity_unique_id ?i64
}

pub fn (t LocatorBarWaypoint) encode(mut w serializer.Writer) {
	w.le_u32(t.update_flag)
	if v := t.visible {
		w.bool(true)
		w.bool(v)
	} else {
		w.bool(false)
	}
	if v := t.world_position {
		w.bool(true)
		v.encode(mut w)
	} else {
		w.bool(false)
	}
	w.write_string(t.texture_path)
	w.le_f32(t.icon_size[0])
	w.le_f32(t.icon_size[1])
	if v := t.color {
		w.bool(true)
		w.le_i32(v)
	} else {
		w.bool(false)
	}
	if v := t.client_authority {
		w.bool(true)
		w.bool(v)
	} else {
		w.bool(false)
	}
	if v := t.entity_unique_id {
		w.bool(true)
		w.write_varint64(v)
	} else {
		w.bool(false)
	}
}

pub fn LocatorBarWaypoint.decode(mut r serializer.Reader) !LocatorBarWaypoint {
	mut t := LocatorBarWaypoint{}
	t.update_flag = r.le_u32()!
	if r.bool()! {
		t.visible = r.bool()!
	}
	if r.bool()! {
		t.world_position = LocatorBarWaypointWorldPosition.decode(mut r)!
	}
	t.texture_path = r.read_string()!
	t.icon_size = [r.le_f32()!, r.le_f32()!]!
	if r.bool()! {
		t.color = r.le_i32()!
	}
	if r.bool()! {
		t.client_authority = r.bool()!
	}
	if r.bool()! {
		t.entity_unique_id = r.read_varint64()!
	}
	return t
}

pub struct LocatorBarPayload {
pub mut:
	group_handle types_662.Uuid
	waypoint     LocatorBarWaypoint
	action       LocatorBarPayloadAction
}

pub fn (t LocatorBarPayload) encode(mut w serializer.Writer) {
	t.group_handle.encode(mut w)
	t.waypoint.encode(mut w)
	t.action.encode(mut w)
}

pub fn LocatorBarPayload.decode(mut r serializer.Reader) !LocatorBarPayload {
	return LocatorBarPayload{
		group_handle: types_662.Uuid.decode(mut r)!
		waypoint:     LocatorBarWaypoint.decode(mut r)!
		action:       LocatorBarPayloadAction.decode(mut r)!
	}
}

pub struct LocatorBarPacket {
pub mut:
	waypoints []LocatorBarPayload
}

pub fn (p &LocatorBarPacket) pid() u16 {
	return 341
}

pub fn (p &LocatorBarPacket) name() string {
	return 'LocatorBarPacket'
}

pub fn (p &LocatorBarPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &LocatorBarPacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint32(u32(p.waypoints.len))
	for e in p.waypoints {
		e.encode(mut w)
	}
}

pub fn (mut p LocatorBarPacket) decode_payload(mut r serializer.Reader) ! {
	count := r.read_count()!
	p.waypoints = []LocatorBarPayload{cap: serializer.prealloc(count)}
	for _ in 0 .. count {
		p.waypoints << LocatorBarPayload.decode(mut r)!
	}
}
