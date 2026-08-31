module types

import protocol.serializer
import bedrock_v.nbt

pub struct ItemData {
pub mut:
	runtime_id      i32
	damage          i32
	count           i32
	has_tag         bool
	tag             nbt.RootTag
	legacy_nbt_data []u8
	can_place       []string
	can_break       []string
}

pub fn (t ItemData) encode(mut w serializer.Writer) {
	if t.runtime_id == 0 {
		w.write_varint32(0)
		return
	}
	w.write_varint32(t.runtime_id)
	mut damage := t.damage
	if damage == -1 {
		damage = 32767
	}
	w.write_varint32(i32((u32(damage) << 8) | u32(t.count & 0xff)))
	if t.has_tag {
		w.le_i16(-1)
		w.u8(1)
		w.write_nbt_compound_root(t.tag)
	} else if t.legacy_nbt_data.len > 0 {
		w.le_i16(i16(t.legacy_nbt_data.len))
		w.write_raw(t.legacy_nbt_data)
	} else {
		w.le_i16(0)
	}
	w.write_varuint32(u32(t.can_place.len))
	for s in t.can_place {
		w.write_string(s)
	}
	w.write_varuint32(u32(t.can_break.len))
	for s in t.can_break {
		w.write_string(s)
	}
}

pub fn ItemData.decode(mut r serializer.Reader) !ItemData {
	mut t := ItemData{}
	t.runtime_id = r.read_varint32()!
	if t.runtime_id == 0 {
		return t
	}
	aux := r.read_varint32()!
	mut damage := i32(i16(aux >> 8))
	if damage == 32767 {
		damage = -1
	}
	t.damage = damage
	t.count = aux & 0xff
	nbt_size := r.le_i16()!
	if nbt_size > 0 {
		t.legacy_nbt_data = r.read_raw(int(nbt_size))!
	} else if nbt_size == -1 {
		tag_count := r.u8()!
		if tag_count != 1 {
			return error('expected 1 tag but got ${tag_count}')
		}
		t.tag = r.read_nbt_compound_root()!
		t.has_tag = true
	}
	place_count := r.read_count()!
	t.can_place = []string{cap: serializer.prealloc(place_count)}
	for _ in 0 .. place_count {
		t.can_place << r.read_string()!
	}
	break_count := r.read_count()!
	t.can_break = []string{cap: serializer.prealloc(break_count)}
	for _ in 0 .. break_count {
		t.can_break << r.read_string()!
	}
	return t
}
