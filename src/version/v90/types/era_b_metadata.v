module types

import protocol.serializer

pub const metadata_end = u8(0x7f)

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

pub struct MetaSlot {
pub mut:
	id     i16
	count  u8
	damage i16
}

pub struct MetaPos {
pub mut:
	x i32
	y i32
	z i32
}

pub struct MetaLong {
pub mut:
	value i64
}

pub type MetadataValue = MetaByte
	| MetaShort
	| MetaInt
	| MetaFloat
	| MetaString
	| MetaSlot
	| MetaPos
	| MetaLong

pub struct MetadataEntry {
pub mut:
	key   u8
	value MetadataValue
}

pub struct EraBMetadata {
pub mut:
	entries []MetadataEntry
}

pub fn (m EraBMetadata) encode(mut w serializer.Writer) {
	for e in m.entries {
		k := e.key & 0x1f
		v := e.value
		match v {
			MetaByte {
				w.u8((u8(0) << 5) | k)
				w.i8(v.value)
			}
			MetaShort {
				w.u8((u8(1) << 5) | k)
				w.le_i16(v.value)
			}
			MetaInt {
				w.u8((u8(2) << 5) | k)
				w.le_i32(v.value)
			}
			MetaFloat {
				w.u8((u8(3) << 5) | k)
				w.le_f32(v.value)
			}
			MetaString {
				w.u8((u8(4) << 5) | k)
				w.le_i16(i16(v.value.len))
				w.write_raw(v.value.bytes())
			}
			MetaSlot {
				w.u8((u8(5) << 5) | k)
				w.le_i16(v.id)
				w.u8(v.count)
				w.le_i16(v.damage)
			}
			MetaPos {
				w.u8((u8(6) << 5) | k)
				w.le_i32(v.x)
				w.le_i32(v.y)
				w.le_i32(v.z)
			}
			MetaLong {
				w.u8((u8(7) << 5) | k)
				w.le_i64(v.value)
			}
		}
	}
	w.u8(metadata_end)
}

pub fn EraBMetadata.decode(mut r serializer.Reader) !EraBMetadata {
	mut m := EraBMetadata{}
	mut b := r.u8()!
	for b != metadata_end {
		key := b & 0x1f
		typ := b >> 5
		mut value := MetadataValue(MetaByte{})
		match typ {
			0 {
				value = MetaByte{
					value: r.i8()!
				}
			}
			1 {
				value = MetaShort{
					value: r.le_i16()!
				}
			}
			2 {
				value = MetaInt{
					value: r.le_i32()!
				}
			}
			3 {
				value = MetaFloat{
					value: r.le_f32()!
				}
			}
			4 {
				len := int(r.le_i16()!)
				value = MetaString{
					value: r.read_raw(len)!.bytestr()
				}
			}
			5 {
				value = MetaSlot{
					id:     r.le_i16()!
					count:  r.u8()!
					damage: r.le_i16()!
				}
			}
			6 {
				value = MetaPos{
					x: r.le_i32()!
					y: r.le_i32()!
					z: r.le_i32()!
				}
			}
			7 {
				value = MetaLong{
					value: r.le_i64()!
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
		b = r.u8()!
	}
	return m
}
