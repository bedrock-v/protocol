module types

import serializer

pub struct OldItem {
pub mut:
	id     i16
	count  u8
	damage i16
}

pub fn (t OldItem) encode(mut w serializer.Writer) {
	w.be_i16(t.id)
	w.u8(t.count)
	w.be_i16(t.damage)
}

pub fn OldItem.decode(mut r serializer.Reader) !OldItem {
	return OldItem{
		id:     r.be_i16()!
		count:  r.u8()!
		damage: r.be_i16()!
	}
}
