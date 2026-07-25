module types

import serializer

pub struct ItemData {
pub mut:
	id        i32
	damage    i32
	count     i32
	nbt_data  []u8
	can_place []string
	can_break []string
}

pub fn (t ItemData) encode(mut w serializer.Writer) {
	if t.id == 0 {
		w.write_varint32(0)
		return
	}
	w.write_varint32(t.id)
	aux := i32(((u32(t.damage) & 0x7fff) << 8) | u32(t.count & 0xff))
	w.write_varint32(aux)
	w.le_i16(i16(t.nbt_data.len))
	w.write_raw(t.nbt_data)
	w.write_varint32(i32(t.can_place.len))
	for s in t.can_place {
		w.write_string(s)
	}
	w.write_varint32(i32(t.can_break.len))
	for s in t.can_break {
		w.write_string(s)
	}
}

pub fn ItemData.decode(mut r serializer.Reader) !ItemData {
	mut t := ItemData{}
	t.id = r.read_varint32()!
	if t.id <= 0 {
		t.id = 0
		return t
	}
	aux := r.read_varint32()!
	mut damage := aux >> 8
	if damage == 0x7fff {
		damage = -1
	}
	t.damage = damage
	t.count = aux & 0xff
	nbt_len := r.le_i16()!
	if nbt_len > 0 {
		t.nbt_data = r.read_raw(int(nbt_len))!
	}
	place_count := r.read_varint32()!
	t.can_place = []string{cap: int(place_count)}
	for _ in 0 .. place_count {
		t.can_place << r.read_string()!
	}
	break_count := r.read_varint32()!
	t.can_break = []string{cap: int(break_count)}
	for _ in 0 .. break_count {
		t.can_break << r.read_string()!
	}
	return t
}
