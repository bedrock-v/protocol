module enums

import protocol.serializer

pub enum PlayerRespawnState as i8 {
	searching_for_spawn   = 0
	ready_to_spawn        = 1
	client_ready_to_spawn = 2
}

pub fn (e PlayerRespawnState) encode(mut w serializer.Writer) {
	w.i8(i8(e))
}

pub fn PlayerRespawnState.decode(mut r serializer.Reader) !PlayerRespawnState {
	return unsafe { PlayerRespawnState(r.i8()!) }
}
