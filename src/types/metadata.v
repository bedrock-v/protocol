module types

import nbt

pub const metadata_type_byte = u32(0)
pub const metadata_type_short = u32(1)
pub const metadata_type_int = u32(2)
pub const metadata_type_float = u32(3)
pub const metadata_type_string = u32(4)
pub const metadata_type_compound_tag = u32(5)
pub const metadata_type_pos = u32(6)
pub const metadata_type_long = u32(7)
pub const metadata_type_vec3 = u32(8)

pub struct MetaByte {
pub mut:
	value i8
}

pub struct MetaShort {
pub mut:
	value i16
}

pub struct MetaInt {
pub mut:
	value i32
}

pub struct MetaFloat {
pub mut:
	value f32
}

pub struct MetaString {
pub mut:
	value string
}

pub struct MetaCompound {
pub mut:
	value nbt.RootTag
}

pub struct MetaBlockPos {
pub mut:
	value BlockPosition
}

pub struct MetaLong {
pub mut:
	value i64
}

pub struct MetaVec3 {
pub mut:
	value Vector3
}

pub type MetadataProperty = MetaBlockPos
	| MetaByte
	| MetaCompound
	| MetaFloat
	| MetaInt
	| MetaLong
	| MetaShort
	| MetaString
	| MetaVec3

pub struct MetadataEntry {
pub mut:
	key   u32
	value MetadataProperty
}

pub fn metadata_type_id(p MetadataProperty) u32 {
	return match p {
		MetaByte { metadata_type_byte }
		MetaShort { metadata_type_short }
		MetaInt { metadata_type_int }
		MetaFloat { metadata_type_float }
		MetaString { metadata_type_string }
		MetaCompound { metadata_type_compound_tag }
		MetaBlockPos { metadata_type_pos }
		MetaLong { metadata_type_long }
		MetaVec3 { metadata_type_vec3 }
	}
}
