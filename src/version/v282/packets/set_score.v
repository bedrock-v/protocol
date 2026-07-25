module packets

import serializer
import version.v291.types

pub enum SetScoreAction as u8 {
	modify = 0
	reset  = 1
}

pub struct ScoreInfo {
pub mut:
	uuid         types.Uuid
	objective_id string
	score        i32
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
		info.uuid.encode(mut w)
		w.write_string(info.objective_id)
		w.le_i32(info.score)
	}
}

pub fn (mut p SetScorePacket) decode_payload(mut r serializer.Reader) ! {
	p.action = unsafe { SetScoreAction(r.u8()!) }
	count := int(r.read_varuint32()!)
	mut infos := []ScoreInfo{cap: count}
	for _ in 0 .. count {
		infos << ScoreInfo{
			uuid:         types.Uuid.decode(mut r)!
			objective_id: r.read_string()!
			score:        r.le_i32()!
		}
	}
	p.infos = infos
}
