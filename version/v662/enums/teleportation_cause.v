module enums

import protocol.serializer

pub enum TeleportationCause as i32 {
	unknown                   = 0
	projectile                = 1
	chorus_fruit              = 2
	command                   = 3
	behavior                  = 4
	teleportation_cause_count = 5
}

pub fn (e TeleportationCause) encode(mut w serializer.Writer) {
	w.le_i32(i32(e))
}

pub fn TeleportationCause.decode(mut r serializer.Reader) !TeleportationCause {
	return unsafe { TeleportationCause(r.le_i32()!) }
}
