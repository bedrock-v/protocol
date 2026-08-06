module enums

import protocol.serializer

pub struct ItemDescEmpty {}

pub struct ItemDescName {
pub mut:
	item_identifier string
	aux_value       i32
}

pub struct ItemDescMolang {
pub mut:
	tag_expression string
	molang_version i16
}

pub struct ItemDescItemTag {
pub mut:
	item_tag string
}

pub type ItemDescriptorType = ItemDescEmpty | ItemDescItemTag | ItemDescMolang | ItemDescName

pub fn (t ItemDescriptorType) type_id() u32 {
	return match t {
		ItemDescEmpty { u32(0) }
		ItemDescName { u32(1) }
		ItemDescMolang { u32(2) }
		ItemDescItemTag { u32(3) }
	}
}

pub fn (t ItemDescriptorType) encode(mut w serializer.Writer) {
	id := t.type_id()
	w.write_varuint32(id)
	w.u8(u8(id))
	match t {
		ItemDescEmpty {}
		ItemDescName {
			w.write_string(t.item_identifier)
			w.write_varint32(t.aux_value)
		}
		ItemDescMolang {
			w.write_string(t.tag_expression)
			w.le_i16(t.molang_version)
		}
		ItemDescItemTag {
			w.write_string(t.item_tag)
		}
	}
}

pub fn ItemDescriptorType.decode(mut r serializer.Reader) !ItemDescriptorType {
	d := r.read_varuint32()!
	r.u8()!
	match d {
		0 {
			return ItemDescEmpty{}
		}
		1 {
			return ItemDescName{
				item_identifier: r.read_string()!
				aux_value:       r.read_varint32()!
			}
		}
		2 {
			return ItemDescMolang{
				tag_expression: r.read_string()!
				molang_version: r.le_i16()!
			}
		}
		3 {
			return ItemDescItemTag{
				item_tag: r.read_string()!
			}
		}
		else {
			return error('invalid ItemDescriptorType ${d}')
		}
	}
}
