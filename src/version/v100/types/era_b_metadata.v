module types

import serializer

pub struct MetaByte {
pub mut:
	value u8
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

pub struct MetaSlot {
pub mut:
	item EraBItem
}

pub struct MetaPos {
pub mut:
	x i32
	y u32
	z i32
}

pub struct MetaLong {
pub mut:
	value i32
}

pub struct MetaVector3f {
pub mut:
	x f32
	y f32
	z f32
}

pub type MetadataValue = MetaByte
	| MetaShort
	| MetaInt
	| MetaFloat
	| MetaString
	| MetaSlot
	| MetaPos
	| MetaLong
	| MetaVector3f

pub struct MetadataEntry {
pub mut:
	key   u32
	value MetadataValue
}

pub struct EraBMetadata {
pub mut:
	entries []MetadataEntry
}

pub fn (m EraBMetadata) encode(mut w serializer.Writer) {
	w.write_varuint32(u32(m.entries.len))
	for e in m.entries {
		w.write_varuint32(e.key)
		v := e.value
		match v {
			MetaByte {
				w.write_varuint32(0)
				w.u8(v.value)
			}
			MetaShort {
				w.write_varuint32(1)
				w.le_i16(v.value)
			}
			MetaInt {
				w.write_varuint32(2)
				w.write_varint32(v.value)
			}
			MetaFloat {
				w.write_varuint32(3)
				w.le_f32(v.value)
			}
			MetaString {
				w.write_varuint32(4)
				w.write_string(v.value)
			}
			MetaSlot {
				w.write_varuint32(5)
				v.item.encode(mut w)
			}
			MetaPos {
				w.write_varuint32(6)
				w.write_varint32(v.x)
				w.write_varuint32(v.y)
				w.write_varint32(v.z)
			}
			MetaLong {
				w.write_varuint32(7)
				w.write_varint32(v.value)
			}
			MetaVector3f {
				w.write_varuint32(8)
				w.le_f32(v.x)
				w.le_f32(v.y)
				w.le_f32(v.z)
			}
		}
	}
}

pub fn EraBMetadata.decode(mut r serializer.Reader) !EraBMetadata {
	mut m := EraBMetadata{}
	count := r.read_varuint32()!
	for _ in 0 .. count {
		key := r.read_varuint32()!
		typ := r.read_varuint32()!
		mut value := MetadataValue(MetaByte{})
		match typ {
			0 {
				value = MetaByte{
					value: r.u8()!
				}
			}
			1 {
				value = MetaShort{
					value: r.le_i16()!
				}
			}
			2 {
				value = MetaInt{
					value: r.read_varint32()!
				}
			}
			3 {
				value = MetaFloat{
					value: r.le_f32()!
				}
			}
			4 {
				value = MetaString{
					value: r.read_string()!
				}
			}
			5 {
				value = MetaSlot{
					item: EraBItem.decode(mut r)!
				}
			}
			6 {
				value = MetaPos{
					x: r.read_varint32()!
					y: r.read_varuint32()!
					z: r.read_varint32()!
				}
			}
			7 {
				value = MetaLong{
					value: r.read_varint32()!
				}
			}
			8 {
				value = MetaVector3f{
					x: r.le_f32()!
					y: r.le_f32()!
					z: r.le_f32()!
				}
			}
			else {
				return error('unknown metadata type ${typ}')
			}
		}
		m.entries << MetadataEntry{
			key:   key
			value: value
		}
	}
	return m
}
