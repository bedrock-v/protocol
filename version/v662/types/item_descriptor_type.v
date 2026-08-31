module types

import protocol.serializer

pub struct ItemDescInvalid {}

pub struct ItemDescDefault {
pub mut:
	item_id   i16
	aux_value i16
}

pub struct ItemDescMolang {
pub mut:
	tag_expression string
	molang_version u8
}

pub struct ItemDescItemTag {
pub mut:
	item_tag string
}

pub struct ItemDescDeferred {
pub mut:
	full_name string
	aux_value i16
}

pub struct ItemDescComplexAlias {
pub mut:
	name string
}

pub type ItemDescriptorType = ItemDescComplexAlias
	| ItemDescDefault
	| ItemDescDeferred
	| ItemDescInvalid
	| ItemDescItemTag
	| ItemDescMolang

pub struct ItemDescriptorCount {
pub mut:
	descriptor ItemDescriptorType = ItemDescInvalid{}
	count      i32
}

pub fn (t ItemDescriptorType) encode(mut w serializer.Writer) {
	match t {
		ItemDescInvalid {
			w.i8(0)
		}
		ItemDescDefault {
			w.i8(1)
			w.le_i16(t.item_id)
			if t.item_id != 0 {
				w.le_i16(t.aux_value)
			}
		}
		ItemDescMolang {
			w.i8(2)
			w.write_string(t.tag_expression)
			w.u8(t.molang_version)
		}
		ItemDescItemTag {
			w.i8(3)
			w.write_string(t.item_tag)
		}
		ItemDescDeferred {
			w.i8(4)
			w.write_string(t.full_name)
			w.le_i16(t.aux_value)
		}
		ItemDescComplexAlias {
			w.i8(5)
			w.write_string(t.name)
		}
	}
}

pub fn ItemDescriptorType.decode(mut r serializer.Reader) !ItemDescriptorType {
	d := r.i8()!
	match d {
		0 {
			return ItemDescInvalid{}
		}
		1 {
			item_id := r.le_i16()!
			aux_value := if item_id != 0 { r.le_i16()! } else { i16(0) }
			return ItemDescDefault{
				item_id:   item_id
				aux_value: aux_value
			}
		}
		2 {
			return ItemDescMolang{
				tag_expression: r.read_string()!
				molang_version: r.u8()!
			}
		}
		3 {
			return ItemDescItemTag{
				item_tag: r.read_string()!
			}
		}
		4 {
			return ItemDescDeferred{
				full_name: r.read_string()!
				aux_value: r.le_i16()!
			}
		}
		5 {
			return ItemDescComplexAlias{
				name: r.read_string()!
			}
		}
		else {
			return error('invalid ItemDescriptorType ${d}')
		}
	}
}

pub fn (t ItemDescriptorCount) encode(mut w serializer.Writer) {
	t.descriptor.encode(mut w)
	w.write_varint32(t.count)
}

pub fn ItemDescriptorCount.decode(mut r serializer.Reader) !ItemDescriptorCount {
	return ItemDescriptorCount{
		descriptor: ItemDescriptorType.decode(mut r)!
		count:      r.read_varint32()!
	}
}
