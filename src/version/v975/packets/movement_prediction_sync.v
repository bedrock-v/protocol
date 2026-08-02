module packets

import protocol.serializer

pub struct MovementPredictionFlags {
pub mut:
	raw_groups []u8
}

const max_movement_prediction_flag_groups = 32

pub fn (d MovementPredictionFlags) encode(mut w serializer.Writer) {
	if d.raw_groups.len == 0 {
		w.u8(0)
		return
	}
	for b in d.raw_groups {
		w.u8(b)
	}
}

pub fn MovementPredictionFlags.decode(mut r serializer.Reader) !MovementPredictionFlags {
	mut groups := []u8{}
	for {
		b := r.u8()!
		groups << b
		if b & 0x80 == 0 {
			break
		}
		if groups.len >= max_movement_prediction_flag_groups {
			return error('MovementPredictionFlags bitset is too long')
		}
	}
	return MovementPredictionFlags{
		raw_groups: groups
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
	entity_unique_id i64
	is_flying        bool
}

pub fn (p &MovementPredictionSyncPacket) pid() u16 {
	return 322
}

pub fn (p &MovementPredictionSyncPacket) name() string {
	return 'MovementPredictionSyncPacket'
}

pub fn (p &MovementPredictionSyncPacket) can_be_sent_before_login() bool {
	return false
}

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
	w.write_varint64(p.entity_unique_id)
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
	p.entity_unique_id = r.read_varint64()!
	p.is_flying = r.bool()!
}
