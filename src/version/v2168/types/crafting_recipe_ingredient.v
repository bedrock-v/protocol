module types

import serializer

const aux_wildcard = i32(0x7fff)

pub struct CraftingDescEmpty {}

pub struct CraftingDescName {
pub mut:
	item_id   string
	aux_value i32
}

pub struct CraftingDescMolang {
pub mut:
	tag_expression string
	molang_version i16
}

pub struct CraftingDescItemTag {
pub mut:
	item_tag string
}

pub type CraftingItemDescriptor = CraftingDescEmpty
	| CraftingDescItemTag
	| CraftingDescMolang
	| CraftingDescName

fn to_aux_value(value i32) i32 {
	if value == -1 {
		return aux_wildcard
	}
	return value
}

fn from_aux_value(value i32) i32 {
	if value == aux_wildcard {
		return -1
	}
	return value
}

pub struct CraftingRecipeIngredient {
pub mut:
	descriptor CraftingItemDescriptor = CraftingDescEmpty{}
	stack_size i32
}

pub fn (t CraftingRecipeIngredient) encode(mut w serializer.Writer) {
	d := t.descriptor
	match d {
		CraftingDescEmpty {
			w.write_varuint32(0)
			w.write_varint32(to_aux_value(-1))
		}
		CraftingDescName {
			w.write_varuint32(1)
			w.write_string('name')
			w.write_string(d.item_id)
			w.write_varint32(to_aux_value(d.aux_value))
		}
		CraftingDescMolang {
			w.write_varuint32(1)
			w.write_string('molang')
			w.write_string(d.tag_expression)
			w.le_i16(d.molang_version)
		}
		CraftingDescItemTag {
			w.write_varuint32(1)
			w.write_string('item_tag')
			w.write_string(d.item_tag)
			w.write_varint32(to_aux_value(-1))
		}
	}
	w.write_varint32(t.stack_size)
}

pub fn CraftingRecipeIngredient.decode(mut r serializer.Reader) !CraftingRecipeIngredient {
	variant := r.read_varuint32()!
	mut descriptor := CraftingItemDescriptor(CraftingDescEmpty{})
	if variant == 0 {
		r.read_varint32()!
	} else {
		type_id := r.read_string()!
		match type_id {
			'empty' {
				descriptor = CraftingDescEmpty{}
			}
			'name' {
				item_id := r.read_string()!
				aux_value := from_aux_value(r.read_varint32()!)
				descriptor = CraftingDescName{
					item_id:   item_id
					aux_value: aux_value
				}
			}
			'molang' {
				descriptor = CraftingDescMolang{
					tag_expression: r.read_string()!
					molang_version: r.le_i16()!
				}
			}
			'item_tag' {
				item_tag := r.read_string()!
				r.read_varint32()!
				descriptor = CraftingDescItemTag{
					item_tag: item_tag
				}
			}
			else {
				return error('invalid CraftingItemDescriptor ${type_id}')
			}
		}
	}
	return CraftingRecipeIngredient{
		descriptor: descriptor
		stack_size: r.read_varint32()!
	}
}
