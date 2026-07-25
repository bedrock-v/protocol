module types

import serializer

pub struct BossEventAdd {
pub mut:
	name           string
	health_percent f32
	darken_screen  u16
	color          u32
	overlay        u32
}

pub struct BossEventPlayerAdded {
pub mut:
	player_id ActorUniqueID
}

pub struct BossEventRemove {}

pub struct BossEventPlayerRemoved {
pub mut:
	player_id ActorUniqueID
}

pub struct BossEventUpdatePercent {
pub mut:
	health_percent f32
}

pub struct BossEventUpdateName {
pub mut:
	name string
}

pub struct BossEventUpdateProperties {
pub mut:
	darken_screen u16
	color         u32
	overlay       u32
}

pub struct BossEventUpdateStyle {
pub mut:
	color   u32
	overlay u32
}

pub struct BossEventQuery {
pub mut:
	player_id ActorUniqueID
}

pub type BossEventUpdateType = BossEventAdd
	| BossEventPlayerAdded
	| BossEventPlayerRemoved
	| BossEventQuery
	| BossEventRemove
	| BossEventUpdateName
	| BossEventUpdatePercent
	| BossEventUpdateProperties
	| BossEventUpdateStyle

pub fn (t BossEventUpdateType) encode(mut w serializer.Writer) {
	match t {
		BossEventAdd {
			w.le_i32(0)
			w.write_string(t.name)
			w.le_f32(t.health_percent)
			w.le_u16(t.darken_screen)
			w.write_varuint32(t.color)
			w.write_varuint32(t.overlay)
		}
		BossEventPlayerAdded {
			w.le_i32(1)
			t.player_id.encode(mut w)
		}
		BossEventRemove { w.le_i32(2) }
		BossEventPlayerRemoved {
			w.le_i32(3)
			t.player_id.encode(mut w)
		}
		BossEventUpdatePercent {
			w.le_i32(4)
			w.le_f32(t.health_percent)
		}
		BossEventUpdateName {
			w.le_i32(5)
			w.write_string(t.name)
		}
		BossEventUpdateProperties {
			w.le_i32(6)
			w.le_u16(t.darken_screen)
			w.write_varuint32(t.color)
			w.write_varuint32(t.overlay)
		}
		BossEventUpdateStyle {
			w.le_i32(7)
			w.write_varuint32(t.color)
			w.write_varuint32(t.overlay)
		}
		BossEventQuery {
			w.le_i32(8)
			t.player_id.encode(mut w)
		}
	}
}

pub fn BossEventUpdateType.decode(mut r serializer.Reader) !BossEventUpdateType {
	d := r.le_i32()!
	match d {
		0 {
			return BossEventAdd{
				name:           r.read_string()!
				health_percent: r.le_f32()!
				darken_screen:  r.le_u16()!
				color:          r.read_varuint32()!
				overlay:        r.read_varuint32()!
			}
		}
		1 { return BossEventPlayerAdded{ player_id: ActorUniqueID.decode(mut r)! } }
		2 { return BossEventRemove{} }
		3 { return BossEventPlayerRemoved{ player_id: ActorUniqueID.decode(mut r)! } }
		4 { return BossEventUpdatePercent{ health_percent: r.le_f32()! } }
		5 { return BossEventUpdateName{ name: r.read_string()! } }
		6 {
			return BossEventUpdateProperties{
				darken_screen: r.le_u16()!
				color:         r.read_varuint32()!
				overlay:       r.read_varuint32()!
			}
		}
		7 { return BossEventUpdateStyle{ color: r.read_varuint32()!, overlay: r.read_varuint32()! } }
		8 { return BossEventQuery{ player_id: ActorUniqueID.decode(mut r)! } }
		else { return error('invalid BossEventUpdateType ${d}') }
	}
}
