module serializer

import src.types

pub fn (mut r Reader) read_metadata_property(type_id u32) !types.MetadataProperty {
	match type_id {
		types.metadata_type_byte {
			return types.MetadataProperty(types.MetaByte{
				value: r.i8()!
			})
		}
		types.metadata_type_short {
			return types.MetadataProperty(types.MetaShort{
				value: r.le_i16()!
			})
		}
		types.metadata_type_int {
			return types.MetadataProperty(types.MetaInt{
				value: r.read_varint32()!
			})
		}
		types.metadata_type_float {
			return types.MetadataProperty(types.MetaFloat{
				value: r.le_f32()!
			})
		}
		types.metadata_type_string {
			return types.MetadataProperty(types.MetaString{
				value: r.read_string()!
			})
		}
		types.metadata_type_compound_tag {
			return types.MetadataProperty(types.MetaCompound{
				value: r.read_nbt_compound_root()!
			})
		}
		types.metadata_type_pos {
			return types.MetadataProperty(types.MetaBlockPos{
				value: r.read_block_position()!
			})
		}
		types.metadata_type_long {
			return types.MetadataProperty(types.MetaLong{
				value: r.read_varint64()!
			})
		}
		types.metadata_type_vec3 {
			return types.MetadataProperty(types.MetaVec3{
				value: r.read_vector3()!
			})
		}
		else {
			return error('unknown entity metadata type ${type_id}')
		}
	}
}

pub fn (mut w Writer) write_metadata_property(p types.MetadataProperty) {
	match p {
		types.MetaByte { w.i8(p.value) }
		types.MetaShort { w.le_i16(p.value) }
		types.MetaInt { w.write_varint32(p.value) }
		types.MetaFloat { w.le_f32(p.value) }
		types.MetaString { w.write_string(p.value) }
		types.MetaCompound { w.write_nbt_compound_root(p.value) }
		types.MetaBlockPos { w.write_block_position(p.value) }
		types.MetaLong { w.write_varint64(p.value) }
		types.MetaVec3 { w.write_vector3(p.value) }
	}
}

pub fn (mut r Reader) read_entity_metadata() ![]types.MetadataEntry {
	count := int(r.read_varuint32()!)
	mut entries := []types.MetadataEntry{cap: count}
	for _ in 0 .. count {
		key := r.read_varuint32()!
		type_id := r.read_varuint32()!
		value := r.read_metadata_property(type_id)!
		entries << types.MetadataEntry{
			key:   key
			value: value
		}
	}
	return entries
}

pub fn (mut w Writer) write_entity_metadata(entries []types.MetadataEntry) {
	w.write_varuint32(u32(entries.len))
	for entry in entries {
		w.write_varuint32(entry.key)
		w.write_varuint32(types.metadata_type_id(entry.value))
		w.write_metadata_property(entry.value)
	}
}

pub fn (mut r Reader) read_property_sync_data() !types.PropertySyncData {
	int_count := int(r.read_varuint32()!)
	mut int_properties := []types.IntProperty{cap: int_count}
	for _ in 0 .. int_count {
		int_properties << types.IntProperty{
			key:   r.read_varuint32()!
			value: r.read_varint32()!
		}
	}
	float_count := int(r.read_varuint32()!)
	mut float_properties := []types.FloatProperty{cap: float_count}
	for _ in 0 .. float_count {
		float_properties << types.FloatProperty{
			key:   r.read_varuint32()!
			value: r.le_f32()!
		}
	}
	return types.PropertySyncData{
		int_properties:   int_properties
		float_properties: float_properties
	}
}

pub fn (mut w Writer) write_property_sync_data(data types.PropertySyncData) {
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
