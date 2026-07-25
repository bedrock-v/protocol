module packets

import serializer
import version.v291.types as types_291

pub enum RespawnState as u8 {
	server_searching = 0
	server_ready     = 1
	client_ready     = 2
}

pub struct RespawnPacket {
pub mut:
	position          types_291.Vector3f
	state             RespawnState
	runtime_entity_id u64
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
	p.position.encode(mut w)
	w.u8(u8(p.state))
	w.write_varuint64(p.runtime_entity_id)
}

pub fn (mut p RespawnPacket) decode_payload(mut r serializer.Reader) ! {
	p.position = types_291.Vector3f.decode(mut r)!
	p.state = unsafe { RespawnState(r.u8()!) }
	p.runtime_entity_id = r.read_varuint64()!
}
