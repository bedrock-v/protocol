module packets

import serializer
import version.v662.types as types_662

pub struct MovementPredictionFlags {
pub mut:
	lo u64
	hi u64
}

pub fn (d MovementPredictionFlags) encode(mut w serializer.Writer) {
	mut lo := d.lo
	mut hi := d.hi
	for {
		b := u8(lo & 0x7f)
		lo = (lo >> 7) | (hi << 57)
		hi = hi >> 7
		if lo == 0 && hi == 0 {
			w.u8(b)
			break
		}
		w.u8(b | 0x80)
	}
}

pub fn MovementPredictionFlags.decode(mut r serializer.Reader) !MovementPredictionFlags {
	mut lo := u64(0)
	mut hi := u64(0)
	mut shift := 0
	for {
		b := r.u8()!
		v := u64(b & 0x7f)
		if shift < 64 {
			lo |= v << u64(shift)
			if shift > 57 {
				hi |= v >> u64(64 - shift)
			}
		} else {
			hi |= v << u64(shift - 64)
		}
		if b & 0x80 == 0 {
			break
		}
		shift += 7
		if shift >= 128 {
			return error('varuint128 is too long')
		}
	}
	return MovementPredictionFlags{
		lo: lo
		hi: hi
	}
}

pub struct MovementPredictionSyncPacket {
pub mut:
	flags             MovementPredictionFlags
	bounding_box      [3]f32
	speed             f32
	underwater_speed  f32
	lava_speed        f32
	jump_strength     f32
	health            f32
	hunger            f32
	friction_modifier f32
	bounciness        f32
	air_drag_modifier f32
	runtime_entity_id types_662.ActorRuntimeID
	is_flying         bool
}

pub fn (p &MovementPredictionSyncPacket) pid() u16 { return 322 }

pub fn (p &MovementPredictionSyncPacket) name() string { return 'MovementPredictionSyncPacket' }

pub fn (p &MovementPredictionSyncPacket) can_be_sent_before_login() bool { return false }

pub fn (p &MovementPredictionSyncPacket) encode_payload(mut w serializer.Writer) {
	p.flags.encode(mut w)
	w.le_f32(p.bounding_box[0])
	w.le_f32(p.bounding_box[1])
	w.le_f32(p.bounding_box[2])
	w.le_f32(p.speed)
	w.le_f32(p.underwater_speed)
	w.le_f32(p.lava_speed)
	w.le_f32(p.jump_strength)
	w.le_f32(p.health)
	w.le_f32(p.hunger)
	w.le_f32(p.friction_modifier)
	w.le_f32(p.bounciness)
	w.le_f32(p.air_drag_modifier)
	p.runtime_entity_id.encode(mut w)
	w.bool(p.is_flying)
}

pub fn (mut p MovementPredictionSyncPacket) decode_payload(mut r serializer.Reader) ! {
	p.flags = MovementPredictionFlags.decode(mut r)!
	p.bounding_box = [r.le_f32()!, r.le_f32()!, r.le_f32()!]!
	p.speed = r.le_f32()!
	p.underwater_speed = r.le_f32()!
	p.lava_speed = r.le_f32()!
	p.jump_strength = r.le_f32()!
	p.health = r.le_f32()!
	p.hunger = r.le_f32()!
	p.friction_modifier = r.le_f32()!
	p.bounciness = r.le_f32()!
	p.air_drag_modifier = r.le_f32()!
	p.runtime_entity_id = types_662.ActorRuntimeID.decode(mut r)!
	p.is_flying = r.bool()!
}
