module types

import serializer

pub struct EraBItem {
pub mut:
	id     i16
	count  u8
	damage i16
	nbt    []u8
}

pub fn (t EraBItem) encode(mut w serializer.Writer) {
	if t.id == 0 {
		w.be_i16(0)
		return
	}
	w.be_i16(t.id)
	w.u8(t.count)
	w.be_i16(t.damage)
	w.le_i16(i16(t.nbt.len))
	w.write_raw(t.nbt)
}

pub fn EraBItem.decode(mut r serializer.Reader) !EraBItem {
	id := r.be_i16()!
	if id <= 0 {
		return EraBItem{}
	}
	count := r.u8()!
	damage := r.be_i16()!
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
