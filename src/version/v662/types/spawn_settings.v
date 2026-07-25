module types

import serializer
import version.v662.enums

pub struct SpawnSettings {
pub mut:
	spawn_type              enums.SpawnBiomeType
	user_defined_biome_name string
	dimension               i32
}

pub fn (t SpawnSettings) encode(mut w serializer.Writer) {
	t.spawn_type.encode(mut w)
	w.write_string(t.user_defined_biome_name)
	w.write_varint32(t.dimension)
}

pub fn SpawnSettings.decode(mut r serializer.Reader) !SpawnSettings {
	return SpawnSettings{
		spawn_type:              enums.SpawnBiomeType.decode(mut r)!
		user_defined_biome_name: r.read_string()!
		dimension:               r.read_varint32()!
	}
}
