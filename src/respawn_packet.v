module src

import src.serializer
import src.types

pub struct RespawnPacket {
pub mut:
	position         types.Vector3
	respawn_state    int
	actor_runtime_id u64
}

pub fn (p &RespawnPacket) pid() u16 {
	return respawn_packet
}

pub fn (p &RespawnPacket) name() string {
	return 'RespawnPacket'
}

pub fn (p &RespawnPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p RespawnPacket) decode_payload(mut r serializer.Reader) ! {
	p.position = r.read_vector3()!
	p.respawn_state = int(r.u8()!)
	p.actor_runtime_id = r.read_actor_runtime_id()!
}

pub fn (p &RespawnPacket) encode_payload(mut w serializer.Writer) {
	w.write_vector3(p.position)
	w.u8(u8(p.respawn_state))
	w.write_actor_runtime_id(p.actor_runtime_id)
}
