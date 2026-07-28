module packets

import protocol.serializer
import protocol.version.v662.types as types_662

pub struct ScoreEntryRemove {
pub mut:
	scoreboard_id  types_662.ScoreboardId
	objective_name ?string
}

pub struct ScoreEntryChangePlayer {
pub mut:
	scoreboard_id    types_662.ScoreboardId
	objective_name   string
	score_value      i32
	player_unique_id i64
}

pub struct ScoreEntryChangeEntity {
pub mut:
	scoreboard_id  types_662.ScoreboardId
	objective_name string
	score_value    i32
	actor_id       i64
}

pub struct ScoreEntryChangeFakePlayer {
pub mut:
	scoreboard_id    types_662.ScoreboardId
	objective_name   string
	score_value      i32
	fake_player_name string
}

pub type ScorePacketEntry = ScoreEntryChangeEntity
	| ScoreEntryChangeFakePlayer
	| ScoreEntryChangePlayer
	| ScoreEntryRemove

pub fn (t ScorePacketEntry) encode(mut w serializer.Writer) {
	match t {
		ScoreEntryRemove {
			w.write_varuint32(0)
			w.write_string('remove')
			t.scoreboard_id.encode(mut w)
			if v := t.objective_name {
				w.bool(true)
				w.write_string(v)
			} else {
				w.bool(false)
			}
		}
		ScoreEntryChangePlayer {
			w.write_varuint32(1)
			w.write_string('changeplayer')
			t.scoreboard_id.encode(mut w)
			w.write_string(t.objective_name)
			w.le_i32(t.score_value)
			w.write_varint64(t.player_unique_id)
		}
		ScoreEntryChangeEntity {
			w.write_varuint32(2)
			w.write_string('changeentity')
			t.scoreboard_id.encode(mut w)
			w.write_string(t.objective_name)
			w.le_i32(t.score_value)
			w.write_varint64(t.actor_id)
		}
		ScoreEntryChangeFakePlayer {
			w.write_varuint32(3)
			w.write_string('changefakeplayer')
			t.scoreboard_id.encode(mut w)
			w.write_string(t.objective_name)
			w.le_i32(t.score_value)
			w.write_string(t.fake_player_name)
		}
	}
}

pub fn ScorePacketEntry.decode(mut r serializer.Reader) !ScorePacketEntry {
	d := r.read_varuint32()!
	r.read_string()!
	match d {
		0 {
			mut e := ScoreEntryRemove{
				scoreboard_id: types_662.ScoreboardId.decode(mut r)!
			}
			if r.bool()! {
				e.objective_name = r.read_string()!
			}
			return e
		}
		1 {
			return ScoreEntryChangePlayer{
				scoreboard_id:    types_662.ScoreboardId.decode(mut r)!
				objective_name:   r.read_string()!
				score_value:      r.le_i32()!
				player_unique_id: r.read_varint64()!
			}
		}
		2 {
			return ScoreEntryChangeEntity{
				scoreboard_id:  types_662.ScoreboardId.decode(mut r)!
				objective_name: r.read_string()!
				score_value:    r.le_i32()!
				actor_id:       r.read_varint64()!
			}
		}
		3 {
			return ScoreEntryChangeFakePlayer{
				scoreboard_id:    types_662.ScoreboardId.decode(mut r)!
				objective_name:   r.read_string()!
				score_value:      r.le_i32()!
				fake_player_name: r.read_string()!
			}
		}
		else {
			return error('invalid ScorePacketEntry ${d}')
		}
	}
}

pub struct SetScorePacket {
pub mut:
	score_info []ScorePacketEntry
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
	w.write_varuint32(u32(p.score_info.len))
	for e in p.score_info {
		e.encode(mut w)
	}
}

pub fn (mut p SetScorePacket) decode_payload(mut r serializer.Reader) ! {
	count := int(r.read_varuint32()!)
	p.score_info = []ScorePacketEntry{cap: count}
	for _ in 0 .. count {
		p.score_info << ScorePacketEntry.decode(mut r)!
	}
}
