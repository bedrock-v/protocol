module protocol


pub fn (mut r Reader) read_metadata_property(type_id u32) !MetadataProperty {
	match type_id {
		metadata_type_byte {
			return MetadataProperty(MetaByte{
				value: r.i8()!
			})
		}
		metadata_type_short {
			return MetadataProperty(MetaShort{
				value: r.le_i16()!
			})
		}
		metadata_type_int {
			return MetadataProperty(MetaInt{
				value: r.read_varint32()!
			})
		}
		metadata_type_float {
			return MetadataProperty(MetaFloat{
				value: r.le_f32()!
			})
		}
		metadata_type_string {
			return MetadataProperty(MetaString{
				value: r.read_string()!
			})
		}
		metadata_type_compound_tag {
			return MetadataProperty(MetaCompound{
				value: r.read_nbt_compound_root()!
			})
		}
		metadata_type_pos {
			return MetadataProperty(MetaBlockPos{
				value: r.read_block_position()!
			})
		}
		metadata_type_long {
			return MetadataProperty(MetaLong{
				value: r.read_varint64()!
			})
		}
		metadata_type_vec3 {
			return MetadataProperty(MetaVec3{
				value: r.read_vector3()!
			})
		}
		else {
			return error('unknown entity metadata type ${type_id}')
		}
	}
}

pub fn (mut w Writer) write_metadata_property(p MetadataProperty) {
	match p {
		MetaByte { w.i8(p.value) }
		MetaShort { w.le_i16(p.value) }
		MetaInt { w.write_varint32(p.value) }
		MetaFloat { w.le_f32(p.value) }
		MetaString { w.write_string(p.value) }
		MetaCompound { w.write_nbt_compound_root(p.value) }
		MetaBlockPos { w.write_block_position(p.value) }
		MetaLong { w.write_varint64(p.value) }
		MetaVec3 { w.write_vector3(p.value) }
	}
}

pub fn (mut r Reader) read_entity_metadata() ![]MetadataEntry {
	count := int(r.read_varuint32()!)
	mut entries := []MetadataEntry{cap: count}
	for _ in 0 .. count {
		key := r.read_varuint32()!
		type_id := r.read_varuint32()!
		value := r.read_metadata_property(type_id)!
		entries << MetadataEntry{
			key:   key
			value: value
		}
	}
	return entries
}

pub fn (mut w Writer) write_entity_metadata(entries []MetadataEntry) {
	w.write_varuint32(u32(entries.len))
	for entry in entries {
		w.write_varuint32(entry.key)
		w.write_varuint32(metadata_type_id(entry.value))
		w.write_metadata_property(entry.value)
	}
}

pub fn (mut r Reader) read_property_sync_data() !PropertySyncData {
	int_count := int(r.read_varuint32()!)
	mut int_properties := []IntProperty{cap: int_count}
	for _ in 0 .. int_count {
		int_properties << IntProperty{
			key:   r.read_varuint32()!
			value: r.read_varint32()!
		}
	}
	float_count := int(r.read_varuint32()!)
	mut float_properties := []FloatProperty{cap: float_count}
	for _ in 0 .. float_count {
		float_properties << FloatProperty{
			key:   r.read_varuint32()!
			value: r.le_f32()!
		}
	}
	return PropertySyncData{
		int_properties:   int_properties
		float_properties: float_properties
	}
}

pub fn (mut w Writer) write_property_sync_data(data PropertySyncData) {
	w.write_varuint32(u32(data.int_properties.len))
	for prop in data.int_properties {
		w.write_varuint32(prop.key)
		w.write_varint32(prop.value)
	}
	w.write_varuint32(u32(data.float_properties.len))
	for prop in data.float_properties {
		w.write_varuint32(prop.key)
		w.le_f32(prop.value)
	}
}
