module packets

import protocol.serializer
import protocol.version.v662.types
import protocol.version.v662.enums

pub struct MovePlayerPacket {
pub mut:
	player_runtime_id types.ActorRuntimeID
	position          [3]f32
	rotation          [2]f32
	y_head_rotation   f32
	position_mode     enums.PlayerPositionMode = enums.PlayerPositionNormal{}
	on_ground         bool
	riding_runtime_id types.ActorRuntimeID
	tick              u64
}

pub fn (p &MovePlayerPacket) pid() u16 {
	return 19
}

pub fn (p &MovePlayerPacket) name() string {
	return 'MovePlayerPacket'
}

pub fn (p &MovePlayerPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &MovePlayerPacket) encode_payload(mut w serializer.Writer) {
	p.player_runtime_id.encode(mut w)
	w.le_f32(p.position[0])
	w.le_f32(p.position[1])
	w.le_f32(p.position[2])
	w.le_f32(p.rotation[0])
	w.le_f32(p.rotation[1])
	w.le_f32(p.y_head_rotation)
	w.i8(p.position_mode.id())
	w.bool(p.on_ground)
	p.riding_runtime_id.encode(mut w)
	p.position_mode.encode_payload(mut w)
	w.write_varuint64(p.tick)
}

pub fn (mut p MovePlayerPacket) decode_payload(mut r serializer.Reader) ! {
	p.player_runtime_id = types.ActorRuntimeID.decode(mut r)!
	p.position = [r.le_f32()!, r.le_f32()!, r.le_f32()!]!
	p.rotation = [r.le_f32()!, r.le_f32()!]!
	p.y_head_rotation = r.le_f32()!
	mode_id := r.i8()!
	p.on_ground = r.bool()!
	p.riding_runtime_id = types.ActorRuntimeID.decode(mut r)!
	p.position_mode = enums.PlayerPositionMode.decode_payload(mode_id, mut r)!
	p.tick = r.read_varuint64()!
}
