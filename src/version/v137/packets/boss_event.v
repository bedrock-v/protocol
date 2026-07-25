module packets

import serializer

pub struct BossEventPacket {
pub mut:
	boss_eid       i64
	event_type     u32
	player_eid     i64
	health_percent f32
	title          string
	unknown_short  i16
	color          u32
	overlay        u32
}

pub fn (p &BossEventPacket) pid() u16 {
	return 74
}

pub fn (p &BossEventPacket) name() string {
	return 'BossEventPacket'
}

pub fn (p &BossEventPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &BossEventPacket) encode_payload(mut w serializer.Writer) {
	w.write_varint64(p.boss_eid)
	w.write_varuint32(p.event_type)
	match p.event_type {
		1, 3 {
			w.write_varint64(p.player_eid)
		}
		0 {
			w.write_string(p.title)
			w.le_f32(p.health_percent)
			w.le_i16(p.unknown_short)
			w.write_varuint32(p.color)
			w.write_varuint32(p.overlay)
		}
		6 {
			w.le_i16(p.unknown_short)
			w.write_varuint32(p.color)
			w.write_varuint32(p.overlay)
		}
		7 {
			w.write_varuint32(p.color)
			w.write_varuint32(p.overlay)
		}
		4 {
			w.le_f32(p.health_percent)
		}
		5 {
			w.write_string(p.title)
		}
		else {}
	}
}

pub fn (mut p BossEventPacket) decode_payload(mut r serializer.Reader) ! {
	p.boss_eid = r.read_varint64()!
	p.event_type = r.read_varuint32()!
	match p.event_type {
		1, 3 {
			p.player_eid = r.read_varint64()!
		}
		0 {
			p.title = r.read_string()!
			p.health_percent = r.le_f32()!
			p.unknown_short = r.le_i16()!
			p.color = r.read_varuint32()!
			p.overlay = r.read_varuint32()!
		}
		6 {
			p.unknown_short = r.le_i16()!
			p.color = r.read_varuint32()!
			p.overlay = r.read_varuint32()!
		}
		7 {
			p.color = r.read_varuint32()!
			p.overlay = r.read_varuint32()!
		}
		4 {
			p.health_percent = r.le_f32()!
		}
		5 {
			p.title = r.read_string()!
		}
		else {}
	}
}
