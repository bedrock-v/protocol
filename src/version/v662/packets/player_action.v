module packets

import protocol.serializer
import protocol.version.v662.types
import protocol.version.v662.enums

pub struct PlayerActionPacket {
pub mut:
	player_runtime_id types.ActorRuntimeID
	action            enums.PlayerActionType
	block_position    types.NetworkBlockPosition
	result_pos        types.NetworkBlockPosition
	face              i32
}

pub fn (p &PlayerActionPacket) pid() u16 {
	return 36
}

pub fn (p &PlayerActionPacket) name() string {
	return 'PlayerActionPacket'
}

pub fn (p &PlayerActionPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &PlayerActionPacket) encode_payload(mut w serializer.Writer) {
	p.player_runtime_id.encode(mut w)
	p.action.encode(mut w)
	p.block_position.encode(mut w)
	p.result_pos.encode(mut w)
	w.write_varint32(p.face)
}

pub fn (mut p PlayerActionPacket) decode_payload(mut r serializer.Reader) ! {
	p.player_runtime_id = types.ActorRuntimeID.decode(mut r)!
	p.action = enums.PlayerActionType.decode(mut r)!
	p.block_position = types.NetworkBlockPosition.decode(mut r)!
	p.result_pos = types.NetworkBlockPosition.decode(mut r)!
	p.face = r.read_varint32()!
}
