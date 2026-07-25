module types

import serializer

pub struct EraBItem {
pub mut:
	id     i32
	count  i32
	damage i32
	nbt    []u8
}

pub fn (t EraBItem) encode(mut w serializer.Writer) {
	if t.id == 0 {
		w.write_varint32(0)
		return
	}
	w.write_varint32(t.id)
	aux := (t.damage << 8) | (t.count & 0xff)
	w.write_varint32(aux)
	w.le_i16(i16(t.nbt.len))
	w.write_raw(t.nbt)
}

pub fn EraBItem.decode(mut r serializer.Reader) !EraBItem {
	id := r.read_varint32()!
	if id <= 0 {
		return EraBItem{}
	}
	aux := r.read_varint32()!
	damage := aux >> 8
	count := aux & 0xff
	nbt_len := int(r.le_i16()!)
	mut nbt := []u8{}
	if nbt_len > 0 {
		nbt = r.read_raw(nbt_len)!
	}
	return EraBItem{
		id:     id
		count:  count
		damage: damage
		nbt:    nbt
	}
}
