module packets

import protocol.serializer
import protocol.version.v291.types

pub enum ScoreboardIdentityAction as u8 {
	add    = 0
	remove = 1
}

pub struct ScoreboardIdentityEntry {
pub mut:
	scoreboard_id i64
	uuid          types.Uuid
}

pub struct SetScoreboardIdentityPacket {
pub mut:
	action  ScoreboardIdentityAction
	entries []ScoreboardIdentityEntry
}

pub fn (p &SetScoreboardIdentityPacket) pid() u16 {
	return 112
}

pub fn (p &SetScoreboardIdentityPacket) name() string {
	return 'SetScoreboardIdentityPacket'
}

pub fn (p &SetScoreboardIdentityPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &SetScoreboardIdentityPacket) encode_payload(mut w serializer.Writer) {
	w.u8(u8(p.action))
	w.write_varuint32(u32(p.entries.len))
	for entry in p.entries {
		w.write_varint64(entry.scoreboard_id)
		if p.action == .add {
			entry.uuid.encode(mut w)
		}
	}
}

pub fn (mut p SetScoreboardIdentityPacket) decode_payload(mut r serializer.Reader) ! {
	p.action = unsafe { ScoreboardIdentityAction(r.u8()!) }
	count := int(r.read_varuint32()!)
	mut entries := []ScoreboardIdentityEntry{cap: count}
	for _ in 0 .. count {
		mut entry := ScoreboardIdentityEntry{
			scoreboard_id: r.read_varint64()!
		}
		if p.action == .add {
			entry.uuid = types.Uuid.decode(mut r)!
		}
		entries << entry
	}
	p.entries = entries
}
