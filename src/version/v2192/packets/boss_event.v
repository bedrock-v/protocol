module packets

import protocol.serializer
import protocol.version.v662.types

pub struct BossEventPacket {
pub mut:
	target_actor_id types.ActorUniqueID
	event_type      BossEventUpdateType
	name            string
	filtered_name   string
	health_percent  f32
	color           u8
	overlay         u8
}

pub fn (p &BossEventPacket) pid() u16 {
	return 74
}

pub fn (p &BossEventPacket) name() string {
	return 'BossEventPacket'
}

pub fn (p &BossEventPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &BossEventPacket) encode_payload(mut w serializer.Writer) {
	p.target_actor_id.encode(mut w)
	p.event_type.encode(mut w)
	w.write_string(p.name)
	w.write_string(p.filtered_name)
	w.le_f32(p.health_percent)
	w.u8(p.color)
	w.u8(p.overlay)
}

pub fn (mut p BossEventPacket) decode_payload(mut r serializer.Reader) ! {
	p.target_actor_id = types.ActorUniqueID.decode(mut r)!
	p.event_type = BossEventUpdateType.decode(mut r)!
	p.name = r.read_string()!
	p.filtered_name = r.read_string()!
	p.health_percent = r.le_f32()!
	p.color = r.u8()!
	p.overlay = r.u8()!
}

pub enum BossEventUpdateType as u8 {
	add               = 0
	player_added      = 1
	remove            = 2
	player_removed    = 3
	update_percent    = 4
	update_name       = 5
	update_properties = 6
	update_style      = 7
	query             = 8
}

pub fn (e BossEventUpdateType) encode(mut w serializer.Writer) {
	w.u8(u8(e))
}

pub fn BossEventUpdateType.decode(mut r serializer.Reader) !BossEventUpdateType {
	return unsafe { BossEventUpdateType(r.u8()!) }
}
