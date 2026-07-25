module packets

import serializer

pub struct ActorPickRequestPacket {
pub mut:
	actor_id  i64
	max_slots i8
	with_data bool
}

pub fn (p &ActorPickRequestPacket) pid() u16 { return 35 }

pub fn (p &ActorPickRequestPacket) name() string { return 'ActorPickRequestPacket' }

pub fn (p &ActorPickRequestPacket) can_be_sent_before_login() bool { return false }

pub fn (p &ActorPickRequestPacket) encode_payload(mut w serializer.Writer) {
	w.le_i64(p.actor_id)
	w.i8(p.max_slots)
	w.bool(p.with_data)
}

pub fn (mut p ActorPickRequestPacket) decode_payload(mut r serializer.Reader) ! {
	p.actor_id = r.le_i64()!
	p.max_slots = r.i8()!
	p.with_data = r.bool()!
}
