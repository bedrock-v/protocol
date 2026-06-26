module src

import src.serializer

pub struct ClientMovementPredictionSyncPacket {
pub mut:
	flags                     []u8
	scale                     f32
	width                     f32
	height                    f32
	movement_speed            f32
	underwater_movement_speed f32
	lava_movement_speed       f32
	jump_strength             f32
	health                    f32
	hunger                    f32
	friction_modifier         f32
	bounciness                f32
	air_drag_modifier         f32
	actor_unique_id           i64
	actor_flying_state        bool
}

pub fn (p &ClientMovementPredictionSyncPacket) pid() u16 {
	return client_movement_prediction_sync_packet
}

pub fn (p &ClientMovementPredictionSyncPacket) name() string {
	return 'ClientMovementPredictionSyncPacket'
}

pub fn (p &ClientMovementPredictionSyncPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p ClientMovementPredictionSyncPacket) decode_payload(mut r serializer.Reader) ! {
	p.flags = []u8{}
	for {
		b := r.u8()!
		p.flags << b
		if b & 0x80 == 0 {
			break
		}
	}
	p.scale = r.le_f32()!
	p.width = r.le_f32()!
	p.height = r.le_f32()!
	p.movement_speed = r.le_f32()!
	p.underwater_movement_speed = r.le_f32()!
	p.lava_movement_speed = r.le_f32()!
	p.jump_strength = r.le_f32()!
	p.health = r.le_f32()!
	p.hunger = r.le_f32()!
	p.friction_modifier = r.le_f32()!
	p.bounciness = r.le_f32()!
	p.air_drag_modifier = r.le_f32()!
	p.actor_unique_id = r.read_actor_unique_id()!
	p.actor_flying_state = r.bool()!
}

pub fn (p &ClientMovementPredictionSyncPacket) encode_payload(mut w serializer.Writer) {
	for b in p.flags {
		w.u8(b)
	}
	w.le_f32(p.scale)
	w.le_f32(p.width)
	w.le_f32(p.height)
	w.le_f32(p.movement_speed)
	w.le_f32(p.underwater_movement_speed)
	w.le_f32(p.lava_movement_speed)
	w.le_f32(p.jump_strength)
	w.le_f32(p.health)
	w.le_f32(p.hunger)
	w.le_f32(p.friction_modifier)
	w.le_f32(p.bounciness)
	w.le_f32(p.air_drag_modifier)
	w.write_actor_unique_id(p.actor_unique_id)
	w.bool(p.actor_flying_state)
}
