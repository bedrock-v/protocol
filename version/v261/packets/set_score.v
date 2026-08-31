module packets

import protocol.serializer
import protocol.version.v137.types

pub struct ScorePacketEntry {
pub mut:
	uuid           types.Uuid
	objective_name string
	score          i32
}

pub struct SetScorePacket {
pub mut:
	type    u8
	entries []ScorePacketEntry
}

pub fn (p &SetScorePacket) pid() u16 {
	return 108
}

pub fn (p &SetScorePacket) name() string {
	return 'SetScorePacket'
}

pub fn (p &SetScorePacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &SetScorePacket) encode_payload(mut w serializer.Writer) {
	w.u8(p.type)
	w.write_varuint32(u32(p.entries.len))
	for entry in p.entries {
		entry.uuid.encode(mut w)
		w.write_string(entry.objective_name)
		w.le_i32(entry.score)
	}
}

pub fn (mut p SetScorePacket) decode_payload(mut r serializer.Reader) ! {
	p.type = r.u8()!
	count := r.read_count()!
	p.entries = []ScorePacketEntry{cap: serializer.prealloc(count)}
	for _ in 0 .. count {
		mut entry := ScorePacketEntry{}
		entry.uuid = types.Uuid.decode(mut r)!
		entry.objective_name = r.read_string()!
		entry.score = r.le_i32()!
		p.entries << entry
	}
}
