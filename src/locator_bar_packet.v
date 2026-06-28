module protocol

import serializer
import types

pub struct WorldPosition {
pub mut:
	position  types.Vector3
	dimension int
}

pub struct LocatorBarWaypoint {
pub mut:
	update_flag              u32
	visible                  ?bool
	world_position           ?WorldPosition
	texture_path             ?string
	icon_size                ?types.Vector2
	color                    ?u32
	client_position_authority ?bool
	actor_unique_id          ?i64
}

pub struct LocatorBarWaypointPayload {
pub mut:
	group    types.UUID
	waypoint LocatorBarWaypoint
	action   u8
}

pub struct LocatorBarPacket {
pub mut:
	waypoints []LocatorBarWaypointPayload
}

pub fn (p &LocatorBarPacket) pid() u16 {
	return locator_bar_packet
}

pub fn (p &LocatorBarPacket) name() string {
	return 'LocatorBarPacket'
}

pub fn (p &LocatorBarPacket) can_be_sent_before_login() bool {
	return false
}

fn read_locator_waypoint(mut r serializer.Reader) !LocatorBarWaypoint {
	mut wp := LocatorBarWaypoint{
		update_flag: r.le_u32()!
	}
	if r.bool()! {
		wp.visible = r.bool()!
	}
	if r.bool()! {
		wp.world_position = WorldPosition{
			position:  r.read_vector3()!
			dimension: r.read_varint32()!
		}
	}
	if r.bool()! {
		wp.texture_path = r.read_string()!
	}
	if r.bool()! {
		wp.icon_size = r.read_vector2()!
	}
	if r.bool()! {
		wp.color = r.le_u32()!
	}
	if r.bool()! {
		wp.client_position_authority = r.bool()!
	}
	if r.bool()! {
		wp.actor_unique_id = r.read_actor_unique_id()!
	}
	return wp
}

fn write_locator_waypoint(mut w serializer.Writer, wp LocatorBarWaypoint) {
	w.le_u32(wp.update_flag)
	if v := wp.visible {
		w.bool(true)
		w.bool(v)
	} else {
		w.bool(false)
	}
	if v := wp.world_position {
		w.bool(true)
		w.write_vector3(v.position)
		w.write_varint32(v.dimension)
	} else {
		w.bool(false)
	}
	if v := wp.texture_path {
		w.bool(true)
		w.write_string(v)
	} else {
		w.bool(false)
	}
	if v := wp.icon_size {
		w.bool(true)
		w.write_vector2(v)
	} else {
		w.bool(false)
	}
	if v := wp.color {
		w.bool(true)
		w.le_u32(v)
	} else {
		w.bool(false)
	}
	if v := wp.client_position_authority {
		w.bool(true)
		w.bool(v)
	} else {
		w.bool(false)
	}
	if v := wp.actor_unique_id {
		w.bool(true)
		w.write_actor_unique_id(v)
	} else {
		w.bool(false)
	}
}

pub fn (mut p LocatorBarPacket) decode_payload(mut r serializer.Reader) ! {
	count := r.read_varuint32()!
	p.waypoints = []LocatorBarWaypointPayload{}
	for _ in 0 .. count {
		p.waypoints << LocatorBarWaypointPayload{
			group:    r.read_uuid()!
			waypoint: read_locator_waypoint(mut r)!
			action:   r.u8()!
		}
	}
}

pub fn (p &LocatorBarPacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint32(u32(p.waypoints.len))
	for wp in p.waypoints {
		w.write_uuid(wp.group)
		write_locator_waypoint(mut w, wp.waypoint)
		w.u8(wp.action)
	}
}
