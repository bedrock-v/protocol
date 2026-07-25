module types

import serializer
import version.v662.enums

pub struct ItemEnchant {
pub mut:
	enchant_type  enums.EnchantType
	enchant_level i8
}

pub fn (t ItemEnchant) encode(mut w serializer.Writer) {
	t.enchant_type.encode(mut w)
	w.i8(t.enchant_level)
}

pub fn ItemEnchant.decode(mut r serializer.Reader) !ItemEnchant {
	return ItemEnchant{
		enchant_type:  enums.EnchantType.decode(mut r)!
		enchant_level: r.i8()!
	}
}

pub struct ItemEnchants {
pub mut:
	slot                          i32
	enchants_for_given_activation []ItemEnchant
}

pub fn (t ItemEnchants) encode(mut w serializer.Writer) {
	w.le_i32(t.slot)
	w.write_varuint32(u32(t.enchants_for_given_activation.len))
	for e in t.enchants_for_given_activation {
		e.encode(mut w)
	}
}

pub fn ItemEnchants.decode(mut r serializer.Reader) !ItemEnchants {
	slot := r.le_i32()!
	count := int(r.read_varuint32()!)
	mut items := []ItemEnchant{cap: count}
	for _ in 0 .. count {
		items << ItemEnchant.decode(mut r)!
	}
	return ItemEnchants{
		slot:                          slot
		enchants_for_given_activation: items
	}
}
