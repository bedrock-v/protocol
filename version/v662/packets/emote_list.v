module packets

import protocol.serializer
import protocol.version.v662.types

pub struct EmoteListPacket {
pub mut:
	runtime_id      types.ActorRuntimeID
	emote_piece_ids []types.Uuid
}

pub fn (p &EmoteListPacket) pid() u16 {
	return 152
}

pub fn (p &EmoteListPacket) name() string {
	return 'EmoteListPacket'
}

pub fn (p &EmoteListPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &EmoteListPacket) encode_payload(mut w serializer.Writer) {
	p.runtime_id.encode(mut w)
	w.write_varuint32(u32(p.emote_piece_ids.len))
	for e in p.emote_piece_ids {
		e.encode(mut w)
	}
}

pub fn (mut p EmoteListPacket) decode_payload(mut r serializer.Reader) ! {
	p.runtime_id = types.ActorRuntimeID.decode(mut r)!
	{
		count := r.read_count()!
		p.emote_piece_ids = []types.Uuid{cap: serializer.prealloc(count)}
		for _ in 0 .. count {
			p.emote_piece_ids << types.Uuid.decode(mut r)!
		}
	}
}
