module protocol


pub struct EmoteListPacket {
pub mut:
	player_actor_runtime_id u64
	emote_ids               []UUID
}

pub fn (p &EmoteListPacket) pid() u16 {
	return emote_list_packet
}

pub fn (p &EmoteListPacket) name() string {
	return 'EmoteListPacket'
}

pub fn (p &EmoteListPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p EmoteListPacket) decode_payload(mut r Reader) ! {
	p.player_actor_runtime_id = r.read_actor_runtime_id()!
	count := int(r.read_varuint32()!)
	p.emote_ids = []UUID{cap: count}
	for _ in 0 .. count {
		p.emote_ids << r.read_uuid()!
	}
}

pub fn (p &EmoteListPacket) encode_payload(mut w Writer) {
	w.write_actor_runtime_id(p.player_actor_runtime_id)
	w.write_varuint32(u32(p.emote_ids.len))
	for id in p.emote_ids {
		w.write_uuid(id)
	}
}
