module protocol

import serializer
import types

pub const player_location_type_coordinates = u32(0)

pub struct PlayerLocationPacket {
pub mut:
	type            u32
	actor_unique_id i64
	position        types.Vector3
}

pub fn (p &PlayerLocationPacket) pid() u16 {
	return player_location_packet
}

pub fn (p &PlayerLocationPacket) name() string {
	return 'PlayerLocationPacket'
}

pub fn (p &PlayerLocationPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p PlayerLocationPacket) decode_payload(mut r serializer.Reader) ! {
	p.type = r.le_u32()!
	p.actor_unique_id = r.read_actor_unique_id()!
	if p.type == player_location_type_coordinates {
		p.position = r.read_vector3()!
	}
}

pub fn (p &PlayerLocationPacket) encode_payload(mut w serializer.Writer) {
	w.le_u32(p.type)
	w.write_actor_unique_id(p.actor_unique_id)
	if p.type == player_location_type_coordinates {
		w.write_vector3(p.position)
	}
}
