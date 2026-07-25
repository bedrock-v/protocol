module packets

import serializer
import version.v662.types as types_662

pub struct IdentityInfoEntry {
pub mut:
	scoreboard_id    types_662.ScoreboardId
	player_unique_id i64
}

pub fn (e IdentityInfoEntry) encode(mut w serializer.Writer) {
	e.scoreboard_id.encode(mut w)
	w.write_varint64(e.player_unique_id)
}

pub fn IdentityInfoEntry.decode(mut r serializer.Reader) !IdentityInfoEntry {
	return IdentityInfoEntry{
		scoreboard_id:    types_662.ScoreboardId.decode(mut r)!
		player_unique_id: r.read_varint64()!
	}
}

pub struct SetScoreboardIdentityUpdate {
pub mut:
	entries []IdentityInfoEntry
}

pub struct SetScoreboardIdentityRemove {
pub mut:
	entries []IdentityInfoEntry
}

pub type SetScoreboardIdentityAction = SetScoreboardIdentityRemove | SetScoreboardIdentityUpdate

pub struct SetScoreboardIdentityPacket {
pub mut:
	action SetScoreboardIdentityAction = SetScoreboardIdentityUpdate{}
}

pub fn (p &SetScoreboardIdentityPacket) pid() u16 { return 112 }

pub fn (p &SetScoreboardIdentityPacket) name() string { return 'SetScoreboardIdentityPacket' }

pub fn (p &SetScoreboardIdentityPacket) can_be_sent_before_login() bool { return false }

pub fn (p &SetScoreboardIdentityPacket) encode_payload(mut w serializer.Writer) {
	action := p.action
	match action {
		SetScoreboardIdentityUpdate {
			w.i8(0)
			w.write_varuint32(u32(action.entries.len))
			for e in action.entries {
				e.encode(mut w)
			}
		}
		SetScoreboardIdentityRemove {
			w.i8(1)
			w.write_varuint32(u32(action.entries.len))
			for e in action.entries {
				e.encode(mut w)
			}
		}
	}
}

pub fn (mut p SetScoreboardIdentityPacket) decode_payload(mut r serializer.Reader) ! {
	d := r.i8()!
	count := int(r.read_varuint32()!)
	mut entries := []IdentityInfoEntry{cap: count}
	for _ in 0 .. count {
		entries << IdentityInfoEntry.decode(mut r)!
	}
	match d {
		0 {
			p.action = SetScoreboardIdentityUpdate{
				entries: entries
			}
		}
		1 {
			p.action = SetScoreboardIdentityRemove{
				entries: entries
			}
		}
		else {
			return error('invalid SetScoreboardIdentityPacket ${d}')
		}
	}
}
