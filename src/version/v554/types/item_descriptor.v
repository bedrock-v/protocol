module types

import serializer

pub struct InvalidDescriptor {}

pub struct DefaultDescriptor {
pub mut:
	item_id   i16
	aux_value i16
}

pub struct MolangDescriptor {
pub mut:
	tag_expression string
	molang_version u8
}

pub struct ItemTagDescriptor {
pub mut:
	item_tag string
}

pub struct DeferredDescriptor {
pub mut:
	full_name string
	aux_value i16
}

pub type ItemDescriptor = DefaultDescriptor
	| DeferredDescriptor
	| InvalidDescriptor
	| ItemTagDescriptor
	| MolangDescriptor

pub fn (t ItemDescriptor) encode(mut w serializer.Writer) {
	match t {
		InvalidDescriptor {
			w.u8(0)
		}
		DefaultDescriptor {
			w.u8(1)
			if t.item_id == 0 {
				w.le_i16(0)
			} else {
				w.le_i16(t.item_id)
				w.le_i16(t.aux_value)
			}
		}
		MolangDescriptor {
			w.u8(2)
			w.write_string(t.tag_expression)
			w.u8(t.molang_version)
		}
		ItemTagDescriptor {
			w.u8(3)
			w.write_string(t.item_tag)
		}
		DeferredDescriptor {
			w.u8(4)
			w.write_string(t.full_name)
			w.le_i16(t.aux_value)
		}
	}
}

pub fn ItemDescriptor.decode(mut r serializer.Reader) !ItemDescriptor {
	descriptor_type := r.u8()!
	match descriptor_type {
		1 {
			item_id := r.le_i16()!
			aux_value := if item_id != 0 { r.le_i16()! } else { i16(0) }
			return DefaultDescriptor{
				item_id:   item_id
				aux_value: aux_value
			}
		}
		2 {
			return MolangDescriptor{
				tag_expression: r.read_string()!
				molang_version: r.u8()!
			}
		}
		3 {
			return ItemTagDescriptor{
				item_tag: r.read_string()!
			}
		}
		4 {
			return DeferredDescriptor{
				full_name: r.read_string()!
				aux_value: r.le_i16()!
			}
		}
		else {
			return InvalidDescriptor{}
		}
	}
}

pub struct ItemDescriptorWithCount {
pub mut:
	descriptor ItemDescriptor = InvalidDescriptor{}
	count      i32
}

pub fn (t ItemDescriptorWithCount) encode(mut w serializer.Writer) {
	t.descriptor.encode(mut w)
	w.write_varint32(t.count)
}

pub fn ItemDescriptorWithCount.decode(mut r serializer.Reader) !ItemDescriptorWithCount {
	return ItemDescriptorWithCount{
		descriptor: ItemDescriptor.decode(mut r)!
		count:      r.read_varint32()!
	}
}
