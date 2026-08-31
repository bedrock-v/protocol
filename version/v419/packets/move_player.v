module packets

import protocol.serializer
import protocol.version.v291.types as types_291

pub enum MovePlayerMode as u8 {
	normal        = 0
	respawn       = 1
	teleport      = 2
	head_rotation = 3
}

pub enum TeleportationCause as i32 {
	unknown      = 0
	projectile   = 1
	chorus_fruit = 2
	command      = 3
	behavior     = 4
}

pub struct MovePlayerPacket {
pub mut:
	runtime_entity_id        u64
	position                 types_291.Vector3f
	rotation                 types_291.Vector3f
	mode                     MovePlayerMode
	on_ground                bool
	riding_runtime_entity_id u64
	teleportation_cause      TeleportationCause
	entity_type              i32
	tick                     u64
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
	w.write_varuint64(p.runtime_entity_id)
	p.position.encode(mut w)
	p.rotation.encode(mut w)
	w.u8(u8(p.mode))
	w.bool(p.on_ground)
	w.write_varuint64(p.riding_runtime_entity_id)
	if p.mode == .teleport {
		w.le_i32(i32(p.teleportation_cause))
		w.le_i32(p.entity_type)
	}
	w.write_varuint64(p.tick)
}

pub fn (mut p MovePlayerPacket) decode_payload(mut r serializer.Reader) ! {
	p.runtime_entity_id = r.read_varuint64()!
	p.position = types_291.Vector3f.decode(mut r)!
	p.rotation = types_291.Vector3f.decode(mut r)!
	p.mode = unsafe { MovePlayerMode(r.u8()!) }
	p.on_ground = r.bool()!
	p.riding_runtime_entity_id = r.read_varuint64()!
	if p.mode == .teleport {
		p.teleportation_cause = unsafe { TeleportationCause(r.le_i32()!) }
		p.entity_type = r.le_i32()!
	}
	p.tick = r.read_varuint64()!
}
