module enums

import serializer

pub struct PlayerPositionNormal {}

pub struct PlayerPositionRespawn {}

pub struct PlayerPositionTeleport {
pub mut:
	teleportation_cause i32
	source_actor_type   i32
}

pub struct PlayerPositionOnlyHeadRot {}

pub type PlayerPositionMode = PlayerPositionNormal
	| PlayerPositionOnlyHeadRot
	| PlayerPositionRespawn
	| PlayerPositionTeleport

pub fn (t PlayerPositionMode) id() i8 {
	return match t {
		PlayerPositionNormal { i8(0) }
		PlayerPositionRespawn { i8(1) }
		PlayerPositionTeleport { i8(2) }
		PlayerPositionOnlyHeadRot { i8(3) }
	}
}

pub fn (t PlayerPositionMode) encode_payload(mut w serializer.Writer) {
	match t {
		PlayerPositionTeleport {
			w.le_i32(t.teleportation_cause)
			w.le_i32(t.source_actor_type)
		}
		else {}
	}
}

pub fn PlayerPositionMode.decode_payload(id i8, mut r serializer.Reader) !PlayerPositionMode {
	match id {
		0 { return PlayerPositionNormal{} }
		1 { return PlayerPositionRespawn{} }
		2 {
			return PlayerPositionTeleport{
				teleportation_cause: r.le_i32()!
				source_actor_type:   r.le_i32()!
			}
		}
		3 { return PlayerPositionOnlyHeadRot{} }
		else { return error('invalid PlayerPositionMode ${id}') }
	}
}

pub fn (t PlayerPositionMode) encode(mut w serializer.Writer) {
	w.i8(t.id())
	t.encode_payload(mut w)
}

pub fn PlayerPositionMode.decode(mut r serializer.Reader) !PlayerPositionMode {
	d := r.i8()!
	return PlayerPositionMode.decode_payload(d, mut r)!
}
