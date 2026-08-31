module packets

import protocol.serializer
import protocol.version.v662.types
import protocol.version.v662.enums

pub struct RespawnPacket {
pub mut:
	position          [3]f32
	state             enums.PlayerRespawnState
	player_runtime_id types.ActorRuntimeID
}

pub fn (p &RespawnPacket) pid() u16 {
	return 45
}

pub fn (p &RespawnPacket) name() string {
	return 'RespawnPacket'
}

pub fn (p &RespawnPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &RespawnPacket) encode_payload(mut w serializer.Writer) {
	w.le_f32(p.position[0])
	w.le_f32(p.position[1])
	w.le_f32(p.position[2])
	p.state.encode(mut w)
	p.player_runtime_id.encode(mut w)
}

pub fn (mut p RespawnPacket) decode_payload(mut r serializer.Reader) ! {
	p.position = [r.le_f32()!, r.le_f32()!, r.le_f32()!]!
	p.state = enums.PlayerRespawnState.decode(mut r)!
	p.player_runtime_id = types.ActorRuntimeID.decode(mut r)!
}
