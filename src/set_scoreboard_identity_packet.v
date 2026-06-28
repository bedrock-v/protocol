module protocol

import serializer
import types

pub const scoreboard_identity_type_register = 0
pub const scoreboard_identity_type_clear = 1

pub struct SetScoreboardIdentityPacket {
pub mut:
	type    int
	entries []types.ScoreboardIdentityEntry
}

pub fn (p &SetScoreboardIdentityPacket) pid() u16 {
	return set_scoreboard_identity_packet
}

pub fn (p &SetScoreboardIdentityPacket) name() string {
	return 'SetScoreboardIdentityPacket'
}

pub fn (p &SetScoreboardIdentityPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p SetScoreboardIdentityPacket) decode_payload(mut r serializer.Reader) ! {
	p.type = int(r.u8()!)
	count := int(r.read_varuint32()!)
	p.entries = []types.ScoreboardIdentityEntry{cap: count}
	for _ in 0 .. count {
		mut entry := types.ScoreboardIdentityEntry{
			scoreboard_id: r.read_varint64()!
		}
		if p.type == scoreboard_identity_type_register {
			entry.actor_unique_id = r.read_actor_unique_id()!
		}
		p.entries << entry
	}
}

pub fn (p &SetScoreboardIdentityPacket) encode_payload(mut w serializer.Writer) {
	w.u8(u8(p.type))
	w.write_varuint32(u32(p.entries.len))
	for entry in p.entries {
		w.write_varint64(entry.scoreboard_id)
		if p.type == scoreboard_identity_type_register {
			w.write_actor_unique_id(entry.actor_unique_id)
		}
	}
}
