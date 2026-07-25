module packets

import serializer
import version.v662.types

pub struct ScorePacketInfoChangeEntry {
pub mut:
	id                       types.ScoreboardId
	objective_name           string
	score_value              i32
	identity_definition_type types.IdentityDefinitionType
}

pub fn (e ScorePacketInfoChangeEntry) encode(mut w serializer.Writer) {
	e.id.encode(mut w)
	w.write_string(e.objective_name)
	w.le_i32(e.score_value)
	e.identity_definition_type.encode(mut w)
}

pub fn ScorePacketInfoChangeEntry.decode(mut r serializer.Reader) !ScorePacketInfoChangeEntry {
	return ScorePacketInfoChangeEntry{
		id:                       types.ScoreboardId.decode(mut r)!
		objective_name:           r.read_string()!
		score_value:              r.le_i32()!
		identity_definition_type: types.IdentityDefinitionType.decode(mut r)!
	}
}

pub struct ScorePacketInfoRemoveEntry {
pub mut:
	id             types.ScoreboardId
	objective_name string
	score_value    i32
}

pub fn (e ScorePacketInfoRemoveEntry) encode(mut w serializer.Writer) {
	e.id.encode(mut w)
	w.write_string(e.objective_name)
	w.le_i32(e.score_value)
}

pub fn ScorePacketInfoRemoveEntry.decode(mut r serializer.Reader) !ScorePacketInfoRemoveEntry {
	return ScorePacketInfoRemoveEntry{
		id:             types.ScoreboardId.decode(mut r)!
		objective_name: r.read_string()!
		score_value:    r.le_i32()!
	}
}

pub struct SetScoreChange {
pub mut:
	entries []ScorePacketInfoChangeEntry
}

pub struct SetScoreRemove {
pub mut:
	entries []ScorePacketInfoRemoveEntry
}

pub type SetScoreAction = SetScoreChange | SetScoreRemove

pub struct SetScorePacket {
pub mut:
	action SetScoreAction = SetScoreChange{}
}

pub fn (p &SetScorePacket) pid() u16 { return 108 }

pub fn (p &SetScorePacket) name() string { return 'SetScorePacket' }

pub fn (p &SetScorePacket) can_be_sent_before_login() bool { return false }

pub fn (p &SetScorePacket) encode_payload(mut w serializer.Writer) {
	match p.action {
		SetScoreChange {
			w.i8(0)
			w.write_varuint32(u32(p.action.entries.len))
			for e in p.action.entries {
				e.encode(mut w)
			}
		}
		SetScoreRemove {
			w.i8(1)
			w.write_varuint32(u32(p.action.entries.len))
			for e in p.action.entries {
				e.encode(mut w)
			}
		}
	}
}

pub fn (mut p SetScorePacket) decode_payload(mut r serializer.Reader) ! {
	d := r.i8()!
	match d {
		0 {
			count := int(r.read_varuint32()!)
			mut entries := []ScorePacketInfoChangeEntry{cap: count}
			for _ in 0 .. count {
				entries << ScorePacketInfoChangeEntry.decode(mut r)!
			}
			p.action = SetScoreChange{
				entries: entries
			}
		}
		1 {
			count := int(r.read_varuint32()!)
			mut entries := []ScorePacketInfoRemoveEntry{cap: count}
			for _ in 0 .. count {
				entries << ScorePacketInfoRemoveEntry.decode(mut r)!
			}
			p.action = SetScoreRemove{
				entries: entries
			}
		}
		else {
			return error('invalid SetScorePacket ${d}')
		}
	}
}
