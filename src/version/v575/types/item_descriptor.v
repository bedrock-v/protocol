module types

import protocol.serializer

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

pub struct ComplexAliasDescriptor {
pub mut:
	name string
}

pub type ItemDescriptor = ComplexAliasDescriptor
	| DefaultDescriptor
	| DeferredDescriptor
	| InvalidDescriptor
	| ItemTagDescriptor
	| MolangDescriptor

pub fn (t ItemDescriptor) id() u8 {
	return match t {
		InvalidDescriptor { u8(0) }
		DefaultDescriptor { u8(1) }
		MolangDescriptor { u8(2) }
		ItemTagDescriptor { u8(3) }
		DeferredDescriptor { u8(4) }
		ComplexAliasDescriptor { u8(5) }
	}
}

pub fn (t ItemDescriptor) encode_payload(mut w serializer.Writer) {
	match t {
		InvalidDescriptor {}
		DefaultDescriptor {
			w.le_i16(t.item_id)
			if t.item_id != 0 {
				w.le_i16(t.aux_value)
			}
		}
		MolangDescriptor {
			w.write_string(t.tag_expression)
			w.u8(t.molang_version)
		}
		ItemTagDescriptor {
			w.write_string(t.item_tag)
		}
		DeferredDescriptor {
			w.write_string(t.full_name)
			w.le_i16(t.aux_value)
		}
		ComplexAliasDescriptor {
			w.write_string(t.name)
		}
	}
}

pub fn ItemDescriptor.decode_payload(id u8, mut r serializer.Reader) !ItemDescriptor {
	match id {
		1 {
			item_id := r.le_i16()!
			mut aux_value := i16(0)
			if item_id != 0 {
				aux_value = r.le_i16()!
			}
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
		5 {
			return ComplexAliasDescriptor{
				name: r.read_string()!
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
	w.u8(t.descriptor.id())
	t.descriptor.encode_payload(mut w)
	w.write_varint32(t.count)
}

pub fn ItemDescriptorWithCount.decode(mut r serializer.Reader) !ItemDescriptorWithCount {
	id := r.u8()!
	descriptor := ItemDescriptor.decode_payload(id, mut r)!
	return ItemDescriptorWithCount{
		descriptor: descriptor
		count:      r.read_varint32()!
	}
}
