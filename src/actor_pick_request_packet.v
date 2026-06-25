module src

import src.serializer

pub struct ActorPickRequestPacket {
pub mut:
	actor_unique_id i64
	hotbar_slot     int
	add_user_data   bool
}

pub fn (p &ActorPickRequestPacket) pid() u16 {
	return actor_pick_request_packet
}

pub fn (p &ActorPickRequestPacket) name() string {
	return 'ActorPickRequestPacket'
}

pub fn (p &ActorPickRequestPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p ActorPickRequestPacket) decode_payload(mut r serializer.Reader) ! {
	p.actor_unique_id = r.le_i64()!
	p.hotbar_slot = int(r.u8()!)
	p.add_user_data = r.bool()!
}

pub fn (p &ActorPickRequestPacket) encode_payload(mut w serializer.Writer) {
	w.le_i64(p.actor_unique_id)
	w.u8(u8(p.hotbar_slot))
	w.bool(p.add_user_data)
}
