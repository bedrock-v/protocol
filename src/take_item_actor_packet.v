module src

import src.serializer

pub struct TakeItemActorPacket {
pub mut:
	item_actor_runtime_id  u64
	taker_actor_runtime_id u64
}

pub fn (p &TakeItemActorPacket) pid() u16 {
	return take_item_actor_packet
}

pub fn (p &TakeItemActorPacket) name() string {
	return 'TakeItemActorPacket'
}

pub fn (p &TakeItemActorPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p TakeItemActorPacket) decode_payload(mut r serializer.Reader) ! {
	p.item_actor_runtime_id = r.read_actor_runtime_id()!
	p.taker_actor_runtime_id = r.read_actor_runtime_id()!
}

pub fn (p &TakeItemActorPacket) encode_payload(mut w serializer.Writer) {
	w.write_actor_runtime_id(p.item_actor_runtime_id)
	w.write_actor_runtime_id(p.taker_actor_runtime_id)
}
