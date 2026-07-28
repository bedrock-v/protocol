module packets

import protocol.serializer

pub enum SetScoreAction as u8 {
	set    = 0
	remove = 1
}

pub enum ScorerType as u8 {
	invalid = 0
	player  = 1
	entity  = 2
	fake    = 3
}

pub struct ScoreInfo {
pub mut:
	scoreboard_id i64
	objective_id  string
	score         i32
	scorer_type   ScorerType
	name          string
	entity_id     i64
}

pub struct SetScorePacket {
pub mut:
	action SetScoreAction
	infos  []ScoreInfo
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
	w.u8(u8(p.action))
	w.write_varuint32(u32(p.infos.len))
	for info in p.infos {
		w.write_varint64(info.scoreboard_id)
		w.write_string(info.objective_id)
		w.le_i32(info.score)
		if p.action == .set {
			w.u8(u8(info.scorer_type))
			match info.scorer_type {
				.player, .entity {
					w.write_varint64(info.entity_id)
				}
				.fake {
					w.write_string(info.name)
				}
				.invalid {}
			}
		}
	}
}

pub fn (mut p SetScorePacket) decode_payload(mut r serializer.Reader) ! {
	p.action = unsafe { SetScoreAction(r.u8()!) }
	count := int(r.read_varuint32()!)
	mut infos := []ScoreInfo{cap: count}
	for _ in 0 .. count {
		mut info := ScoreInfo{
			scoreboard_id: r.read_varint64()!
			objective_id:  r.read_string()!
			score:         r.le_i32()!
			entity_id:     -1
		}
		if p.action == .set {
			info.scorer_type = unsafe { ScorerType(r.u8()!) }
			match info.scorer_type {
				.player, .entity {
					info.entity_id = r.read_varint64()!
				}
				.fake {
					info.name = r.read_string()!
				}
				else {
					return error('invalid score info received')
				}
			}
		}
		infos << info
	}
	p.infos = infos
}
