module serializer

import types

pub fn (mut r Reader) read_item_descriptor_count() !types.ItemDescriptorCount {
	mut d := types.ItemDescriptorCount{
		descriptor_type: r.u8()!
	}
	match d.descriptor_type {
		types.item_descriptor_invalid {}
		types.item_descriptor_default {
			d.network_id = r.le_i16()!
			if d.network_id != 0 {
				d.metadata_value = r.le_i16()!
			}
		}
		types.item_descriptor_molang {
			d.expression = r.read_string()!
			d.version = r.u8()!
		}
		types.item_descriptor_item_tag {
			d.tag = r.read_string()!
		}
		types.item_descriptor_deferred {
			d.name = r.read_string()!
			d.metadata_value = r.le_i16()!
		}
		types.item_descriptor_complex_alias {
			d.name = r.read_string()!
		}
		else {}
	}
	d.count = r.read_varint32()!
	return d
}

pub fn (mut w Writer) write_item_descriptor_count(d types.ItemDescriptorCount) {
	w.u8(d.descriptor_type)
	match d.descriptor_type {
		types.item_descriptor_invalid {}
		types.item_descriptor_default {
			w.le_i16(d.network_id)
			if d.network_id != 0 {
				w.le_i16(d.metadata_value)
			}
		}
		types.item_descriptor_molang {
			w.write_string(d.expression)
			w.u8(d.version)
		}
		types.item_descriptor_item_tag {
			w.write_string(d.tag)
		}
		types.item_descriptor_deferred {
			w.write_string(d.name)
			w.le_i16(d.metadata_value)
		}
		types.item_descriptor_complex_alias {
			w.write_string(d.name)
		}
		else {}
	}
	w.write_varint32(d.count)
}
