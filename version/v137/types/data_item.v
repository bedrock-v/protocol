module types

import protocol.serializer

pub struct EntityDataByte {
pub mut:
	value i8
}

pub struct EntityDataShort {
pub mut:
	value i16
}

pub struct EntityDataInt {
pub mut:
	value i32
}

pub struct EntityDataFloat {
pub mut:
	value f32
}

pub struct EntityDataString {
pub mut:
	value string
}

pub struct EntityDataSlot {
pub mut:
	value ItemData
}

pub struct EntityDataPos {
pub mut:
	value Vector3i
}

pub struct EntityDataLong {
pub mut:
	value i64
}

pub struct EntityDataVec3f {
pub mut:
	value Vector3f
}

pub type EntityDataValue = EntityDataByte
	| EntityDataFloat
	| EntityDataInt
	| EntityDataLong
	| EntityDataPos
	| EntityDataShort
	| EntityDataSlot
	| EntityDataString
	| EntityDataVec3f

pub fn (t EntityDataValue) encode(mut w serializer.Writer) {
	match t {
		EntityDataByte {
			w.write_varuint32(0)
			w.i8(t.value)
		}
		EntityDataShort {
			w.write_varuint32(1)
			w.le_i16(t.value)
		}
		EntityDataInt {
			w.write_varuint32(2)
			w.write_varint32(t.value)
		}
		EntityDataFloat {
			w.write_varuint32(3)
			w.le_f32(t.value)
		}
		EntityDataString {
			w.write_varuint32(4)
			w.write_string(t.value)
		}
		EntityDataSlot {
			w.write_varuint32(5)
			t.value.encode(mut w)
		}
		EntityDataPos {
			w.write_varuint32(6)
			t.value.encode(mut w)
		}
		EntityDataLong {
			w.write_varuint32(7)
			w.write_varint64(t.value)
		}
		EntityDataVec3f {
			w.write_varuint32(8)
			t.value.encode(mut w)
		}
	}
}

pub fn EntityDataValue.decode(mut r serializer.Reader, data_type u32) !EntityDataValue {
	match data_type {
		0 {
			return EntityDataByte{
				value: r.i8()!
			}
		}
		1 {
			return EntityDataShort{
				value: r.le_i16()!
			}
		}
		2 {
			return EntityDataInt{
				value: r.read_varint32()!
			}
		}
		3 {
			return EntityDataFloat{
				value: r.le_f32()!
			}
		}
		4 {
			return EntityDataString{
				value: r.read_string()!
			}
		}
		5 {
			return EntityDataSlot{
				value: ItemData.decode(mut r)!
			}
		}
		6 {
			return EntityDataPos{
				value: Vector3i.decode(mut r)!
			}
		}
		7 {
			return EntityDataLong{
				value: r.read_varint64()!
			}
		}
		8 {
			return EntityDataVec3f{
				value: Vector3f.decode(mut r)!
			}
		}
		else {
			return error('invalid entity data type ${data_type}')
		}
	}
}

pub struct DataItem {
pub mut:
	id    u32
	value EntityDataValue = EntityDataByte{}
}

pub fn (t DataItem) encode(mut w serializer.Writer) {
	w.write_varuint32(t.id)
	t.value.encode(mut w)
}

pub fn DataItem.decode(mut r serializer.Reader) !DataItem {
	id := r.read_varuint32()!
	data_type := r.read_varuint32()!
	return DataItem{
		id:    id
		value: EntityDataValue.decode(mut r, data_type)!
	}
}

pub fn write_entity_data(mut w serializer.Writer, items []DataItem) {
	w.write_varuint32(u32(items.len))
	for item in items {
		item.encode(mut w)
	}
}

pub fn read_entity_data(mut r serializer.Reader) ![]DataItem {
	count := r.read_count()!
	mut items := []DataItem{cap: serializer.prealloc(count)}
	for _ in 0 .. count {
		items << DataItem.decode(mut r)!
	}
	return items
}
