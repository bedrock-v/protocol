module packets

import serializer
import version.v662.types

pub struct MovementPredictionSyncPacket {
pub mut:
	flags_low         u64
	flags_high        u64
	bounding_box      [3]f32
	speed             f32
	underwater_speed  f32
	lava_speed        f32
	jump_strength     f32
	health            f32
	hunger            f32
	runtime_entity_id types.ActorRuntimeID
}

pub fn (p &MovementPredictionSyncPacket) pid() u16 { return 322 }

pub fn (p &MovementPredictionSyncPacket) name() string { return 'MovementPredictionSyncPacket' }

pub fn (p &MovementPredictionSyncPacket) can_be_sent_before_login() bool { return false }

pub fn (p &MovementPredictionSyncPacket) encode_payload(mut w serializer.Writer) {
	write_varuint128(mut w, p.flags_low, p.flags_high)
	w.le_f32(p.bounding_box[0])
	w.le_f32(p.bounding_box[1])
	w.le_f32(p.bounding_box[2])
	w.le_f32(p.speed)
	w.le_f32(p.underwater_speed)
	w.le_f32(p.lava_speed)
	w.le_f32(p.jump_strength)
	w.le_f32(p.health)
	w.le_f32(p.hunger)
	p.runtime_entity_id.encode(mut w)
}

pub fn (mut p MovementPredictionSyncPacket) decode_payload(mut r serializer.Reader) ! {
	p.flags_low, p.flags_high = read_varuint128(mut r)!
	p.bounding_box = [r.le_f32()!, r.le_f32()!, r.le_f32()!]!
	p.speed = r.le_f32()!
	p.underwater_speed = r.le_f32()!
	p.lava_speed = r.le_f32()!
	p.jump_strength = r.le_f32()!
	p.health = r.le_f32()!
	p.hunger = r.le_f32()!
	p.runtime_entity_id = types.ActorRuntimeID.decode(mut r)!
}

// flags is a u128 varint on the wire, stored as two u64 halves
fn write_varuint128(mut w serializer.Writer, low u64, high u64) {
	mut lo := low
	mut hi := high
	for hi != 0 || lo >= 0x80 {
		w.u8(u8(lo & 0x7f) | 0x80)
		lo = (lo >> 7) | (hi << 57)
		hi = hi >> 7
	}
	w.u8(u8(lo))
}

fn read_varuint128(mut r serializer.Reader) !(u64, u64) {
	mut lo := u64(0)
	mut hi := u64(0)
	mut shift := u32(0)
	for {
		b := r.u8()!
		v := u64(b & 0x7f)
		if shift < 64 {
			lo |= v << shift
			if shift > 57 {
				hi |= v >> (64 - shift)
			}
		} else {
			hi |= v << (shift - 64)
		}
		if (b & 0x80) == 0 {
			break
		}
		shift += 7
		if shift >= 128 {
			return error('varuint128 did not terminate after 19 bytes')
		}
	}
	return lo, hi
}
