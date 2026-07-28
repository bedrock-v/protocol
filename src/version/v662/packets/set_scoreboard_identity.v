module packets

import protocol.serializer
import protocol.version.v662.types

pub struct IdentityInfoUpdateEntry {
pub mut:
	scoreboard_id    types.ScoreboardId
	player_unique_id i64
}

pub fn (e IdentityInfoUpdateEntry) encode(mut w serializer.Writer) {
	e.scoreboard_id.encode(mut w)
	w.write_varint64(e.player_unique_id)
}

pub fn IdentityInfoUpdateEntry.decode(mut r serializer.Reader) !IdentityInfoUpdateEntry {
	return IdentityInfoUpdateEntry{
		scoreboard_id:    types.ScoreboardId.decode(mut r)!
		player_unique_id: r.read_varint64()!
	}
}

pub struct ScoreboardIdentityUpdate {
pub mut:
	entries []IdentityInfoUpdateEntry
}

pub struct ScoreboardIdentityRemove {
pub mut:
	entries []types.ScoreboardId
}

pub type ScoreboardIdentityAction = ScoreboardIdentityRemove | ScoreboardIdentityUpdate

pub struct SetScoreboardIdentityPacket {
pub mut:
	action ScoreboardIdentityAction = ScoreboardIdentityUpdate{}
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
	match p.action {
		ScoreboardIdentityUpdate {
			w.i8(0)
			w.write_varuint32(u32(p.action.entries.len))
			for e in p.action.entries {
				e.encode(mut w)
			}
		}
		ScoreboardIdentityRemove {
			w.i8(1)
			w.write_varuint32(u32(p.action.entries.len))
			for e in p.action.entries {
				e.encode(mut w)
			}
		}
	}
}

pub fn (mut p SetScoreboardIdentityPacket) decode_payload(mut r serializer.Reader) ! {
	d := r.i8()!
	match d {
		0 {
			count := int(r.read_varuint32()!)
			mut entries := []IdentityInfoUpdateEntry{cap: count}
			for _ in 0 .. count {
				entries << IdentityInfoUpdateEntry.decode(mut r)!
			}
			p.action = ScoreboardIdentityUpdate{
				entries: entries
			}
		}
		1 {
			count := int(r.read_varuint32()!)
			mut entries := []types.ScoreboardId{cap: count}
			for _ in 0 .. count {
				entries << types.ScoreboardId.decode(mut r)!
			}
			p.action = ScoreboardIdentityRemove{
				entries: entries
			}
		}
		else {
			return error('invalid SetScoreboardIdentityPacket ${d}')
		}
	}
}
