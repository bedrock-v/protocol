module types

import protocol.serializer
import nbt

pub fn write_nbt_root(mut w serializer.Writer, root nbt.RootTag) {
	w.write_raw(nbt.encode(root))
}

pub fn read_nbt_root(mut r serializer.Reader) !nbt.RootTag {
	id := r.u8()!
	name := r.read_string()!
	return nbt.RootTag{
		name: name
		tag:  read_tag_payload(mut r, id)!
	}
}

fn read_tag_payload(mut r serializer.Reader, id u8) !nbt.Tag {
	match id {
		nbt.tag_byte {
			return nbt.Tag(r.i8()!)
		}
		nbt.tag_short {
			return nbt.Tag(r.le_i16()!)
		}
		nbt.tag_int {
			return nbt.Tag(r.read_varint32()!)
		}
		nbt.tag_long {
			return nbt.Tag(r.read_varint64()!)
		}
		nbt.tag_float {
			return nbt.Tag(r.le_f32()!)
		}
		nbt.tag_double {
			return nbt.Tag(r.le_f64()!)
		}
		nbt.tag_byte_array {
			length := int(r.read_varint32()!)
			return nbt.Tag(nbt.ByteArray{
				values: r.read_raw(length)!
			})
		}
		nbt.tag_string {
			return nbt.Tag(r.read_string()!)
		}
		nbt.tag_list {
			element_type := r.u8()!
			length := int(r.read_varint32()!)
			mut values := []nbt.Tag{cap: length}
			for _ in 0 .. length {
				values << read_tag_payload(mut r, element_type)!
			}
			return nbt.Tag(nbt.List{
				element_type: element_type
				values:       values
			})
		}
		nbt.tag_compound {
			mut values := map[string]nbt.Tag{}
			for {
				child_id := r.u8()!
				if child_id == nbt.tag_end {
					break
				}
				name := r.read_string()!
				values[name] = read_tag_payload(mut r, child_id)!
			}
			return nbt.Tag(nbt.Compound{
				values: values
			})
		}
		nbt.tag_int_array {
			length := int(r.read_varint32()!)
			mut values := []i32{cap: length}
			for _ in 0 .. length {
				values << r.read_varint32()!
			}
			return nbt.Tag(nbt.IntArray{
				values: values
			})
		}
		nbt.tag_long_array {
			length := int(r.read_varint32()!)
			mut values := []i64{cap: length}
			for _ in 0 .. length {
				values << r.read_varint64()!
			}
			return nbt.Tag(nbt.LongArray{
				values: values
			})
		}
		else {
			return error('invalid nbt tag id ${id}')
		}
	}
}
