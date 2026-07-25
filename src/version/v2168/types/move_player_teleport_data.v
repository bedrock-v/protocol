module types

import serializer

pub struct MovePlayerTeleportData {
pub mut:
	teleportation_cause i32
	source_actor_type   i32
}

pub fn (t MovePlayerTeleportData) encode(mut w serializer.Writer) {
	w.le_i32(t.teleportation_cause)
	w.le_i32(t.source_actor_type)
}

pub fn MovePlayerTeleportData.decode(mut r serializer.Reader) !MovePlayerTeleportData {
	return MovePlayerTeleportData{
		teleportation_cause: r.le_i32()!
		source_actor_type:   r.le_i32()!
	}
}
