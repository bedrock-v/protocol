module packets

import protocol.serializer
import protocol.version.v291.types as types_291

pub struct EmoteListPacket {
pub mut:
	runtime_entity_id u64
	piece_ids         []types_291.Uuid
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
	w.write_varuint64(p.runtime_entity_id)
	w.write_varuint32(u32(p.piece_ids.len))
	for piece_id in p.piece_ids {
		piece_id.encode(mut w)
	}
}

pub fn (mut p EmoteListPacket) decode_payload(mut r serializer.Reader) ! {
	p.runtime_entity_id = r.read_varuint64()!
	count := int(r.read_varuint32()!)
	p.piece_ids = []types_291.Uuid{cap: count}
	for _ in 0 .. count {
		p.piece_ids << types_291.Uuid.decode(mut r)!
	}
}
