module src

import src.serializer
import src.types

pub const set_score_type_change = 0
pub const set_score_type_remove = 1

pub struct SetScorePacket {
pub mut:
	type    int
	entries []types.ScorePacketEntry
}

pub fn (p &SetScorePacket) pid() u16 {
	return set_score_packet
}

pub fn (p &SetScorePacket) name() string {
	return 'SetScorePacket'
}

pub fn (p &SetScorePacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p SetScorePacket) decode_payload(mut r serializer.Reader) ! {
	p.type = int(r.u8()!)
	count := int(r.read_varuint32()!)
	p.entries = []types.ScorePacketEntry{cap: count}
	for _ in 0 .. count {
		mut entry := types.ScorePacketEntry{
			scoreboard_id:  r.read_varint64()!
			objective_name: r.read_string()!
			score:          int(r.le_i32()!)
		}
		if p.type != set_score_type_remove {
			entry.type = int(r.u8()!)
			match entry.type {
				types.score_entry_type_player, types.score_entry_type_entity {
					entry.actor_unique_id = r.read_actor_unique_id()!
				}
				types.score_entry_type_fake_player {
					entry.custom_name = r.read_string()!
				}
				else {
					return error('unknown score entry type ${entry.type}')
				}
			}
		}
		p.entries << entry
	}
}

pub fn (p &SetScorePacket) encode_payload(mut w serializer.Writer) {
	w.u8(u8(p.type))
	w.write_varuint32(u32(p.entries.len))
	for entry in p.entries {
		w.write_varint64(entry.scoreboard_id)
		w.write_string(entry.objective_name)
		w.le_i32(i32(entry.score))
		if p.type != set_score_type_remove {
			w.u8(u8(entry.type))
			match entry.type {
				types.score_entry_type_player, types.score_entry_type_entity {
					w.write_actor_unique_id(entry.actor_unique_id)
				}
				types.score_entry_type_fake_player {
					w.write_string(entry.custom_name)
				}
				else {}
			}
		}
	}
}
