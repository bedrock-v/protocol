module packets

import protocol.serializer

pub struct BossEventCreate {
pub mut:
	title             string
	health_percentage f32
	darken_sky        u16
	color             u32
	overlay           u32
}

pub struct BossEventRegisterPlayer {
pub mut:
	player_unique_entity_id i64
}

pub struct BossEventRemove {}

pub struct BossEventUnregisterPlayer {
pub mut:
	player_unique_entity_id i64
}

pub struct BossEventUpdatePercentage {
pub mut:
	health_percentage f32
}

pub struct BossEventUpdateName {
pub mut:
	title string
}

pub struct BossEventUpdateProperties {
pub mut:
	darken_sky u16
	color      u32
	overlay    u32
}

pub struct BossEventUpdateStyle {
pub mut:
	color   u32
	overlay u32
}

pub struct BossEventQuery {}

pub type BossEventAction = BossEventCreate
	| BossEventQuery
	| BossEventRegisterPlayer
	| BossEventRemove
	| BossEventUnregisterPlayer
	| BossEventUpdateName
	| BossEventUpdatePercentage
	| BossEventUpdateProperties
	| BossEventUpdateStyle

pub fn (t BossEventAction) id() u32 {
	return match t {
		BossEventCreate { u32(0) }
		BossEventRegisterPlayer { u32(1) }
		BossEventRemove { u32(2) }
		BossEventUnregisterPlayer { u32(3) }
		BossEventUpdatePercentage { u32(4) }
		BossEventUpdateName { u32(5) }
		BossEventUpdateProperties { u32(6) }
		BossEventUpdateStyle { u32(7) }
		BossEventQuery { u32(8) }
	}
}

pub fn (t BossEventAction) encode_payload(mut w serializer.Writer) {
	match t {
		BossEventCreate {
			w.write_string(t.title)
			w.le_f32(t.health_percentage)
			w.le_u16(t.darken_sky)
			w.write_varuint32(t.color)
			w.write_varuint32(t.overlay)
		}
		BossEventRegisterPlayer {
			w.write_varint64(t.player_unique_entity_id)
		}
		BossEventRemove {}
		BossEventUnregisterPlayer {
			w.write_varint64(t.player_unique_entity_id)
		}
		BossEventUpdatePercentage {
			w.le_f32(t.health_percentage)
		}
		BossEventUpdateName {
			w.write_string(t.title)
		}
		BossEventUpdateProperties {
			w.le_u16(t.darken_sky)
			w.write_varuint32(t.color)
			w.write_varuint32(t.overlay)
		}
		BossEventUpdateStyle {
			w.write_varuint32(t.color)
			w.write_varuint32(t.overlay)
		}
		BossEventQuery {}
	}
}

pub fn BossEventAction.decode_payload(id u32, mut r serializer.Reader) !BossEventAction {
	match id {
		0 {
			return BossEventCreate{
				title:             r.read_string()!
				health_percentage: r.le_f32()!
				darken_sky:        r.le_u16()!
				color:             r.read_varuint32()!
				overlay:           r.read_varuint32()!
			}
		}
		1 {
			return BossEventRegisterPlayer{
				player_unique_entity_id: r.read_varint64()!
			}
		}
		2 {
			return BossEventRemove{}
		}
		3 {
			return BossEventUnregisterPlayer{
				player_unique_entity_id: r.read_varint64()!
			}
		}
		4 {
			return BossEventUpdatePercentage{
				health_percentage: r.le_f32()!
			}
		}
		5 {
			return BossEventUpdateName{
				title: r.read_string()!
			}
		}
		6 {
			return BossEventUpdateProperties{
				darken_sky: r.le_u16()!
				color:      r.read_varuint32()!
				overlay:    r.read_varuint32()!
			}
		}
		7 {
			return BossEventUpdateStyle{
				color:   r.read_varuint32()!
				overlay: r.read_varuint32()!
			}
		}
		8 {
			return BossEventQuery{}
		}
		else {
			return error('invalid BossEventAction ${id}')
		}
	}
}

pub struct BossEventPacket {
pub mut:
	boss_unique_entity_id i64
	action                BossEventAction = BossEventRemove{}
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
	w.write_varint64(p.boss_unique_entity_id)
	w.write_varuint32(p.action.id())
	p.action.encode_payload(mut w)
}

pub fn (mut p BossEventPacket) decode_payload(mut r serializer.Reader) ! {
	p.boss_unique_entity_id = r.read_varint64()!
	action_id := r.read_varuint32()!
	p.action = BossEventAction.decode_payload(action_id, mut r)!
}
