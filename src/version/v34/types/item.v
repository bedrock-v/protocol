module types

import serializer

pub struct Item {
pub mut:
	id     i16
	count  u8
	damage i16
	nbt    []u8
}

pub fn (t Item) encode(mut w serializer.Writer) {
	if t.id == 0 {
		w.be_i16(0)
		return
	}
	w.be_i16(t.id)
	w.u8(t.count)
	w.be_i16(t.damage)
	w.be_i16(i16(t.nbt.len))
	w.write_raw(t.nbt)
}

pub fn Item.decode(mut r serializer.Reader) !Item {
	id := r.be_i16()!
	if id <= 0 {
		return Item{
			id: 0
		}
	}
	count := r.u8()!
	damage := r.be_i16()!
	nbt_len := int(r.be_i16()!)
	mut nbt := []u8{}
	if nbt_len > 0 {
		nbt = r.read_raw(nbt_len)!
	}
	return Item{
		id:     id
		count:  count
		damage: damage
		nbt:    nbt
	}
}
