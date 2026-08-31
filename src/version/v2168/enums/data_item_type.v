module enums

import protocol.serializer
import bedrock_v.nbt
import protocol.version.v662.types

pub struct DataItemByte {
pub mut:
	value i8
}

pub struct DataItemShort {
pub mut:
	value i16
}

pub struct DataItemInt {
pub mut:
	value i32
}

pub struct DataItemFloat {
pub mut:
	value f32
}

pub struct DataItemString {
pub mut:
	value string
}

pub struct DataItemNBT {
pub mut:
	value nbt.RootTag
}

pub struct DataItemPos {
pub mut:
	value types.BlockPos
}

pub struct DataItemInt64 {
pub mut:
	value i64
}

pub struct DataItemVec3 {
pub mut:
	x f32
	y f32
	z f32
}

pub type DataItemType = DataItemByte
	| DataItemFloat
	| DataItemInt
	| DataItemInt64
	| DataItemNBT
	| DataItemPos
	| DataItemShort
	| DataItemString
	| DataItemVec3

pub fn (t DataItemType) type_id() u32 {
	return match t {
		DataItemByte { u32(0) }
		DataItemShort { u32(1) }
		DataItemInt { u32(2) }
		DataItemFloat { u32(3) }
		DataItemString { u32(4) }
		DataItemNBT { u32(5) }
		DataItemPos { u32(6) }
		DataItemInt64 { u32(7) }
		DataItemVec3 { u32(8) }
	}
}

pub fn (t DataItemType) encode(mut w serializer.Writer) {
	id := t.type_id()
	w.write_varuint32(id)
	// since 1.26.40 the format is written twice: varuint followed by a raw byte
	w.u8(u8(id))
	match t {
		DataItemByte {
			w.i8(t.value)
		}
		DataItemShort {
			w.le_i16(t.value)
		}
		DataItemInt {
			w.write_varint32(t.value)
		}
		DataItemFloat {
			w.le_f32(t.value)
		}
		DataItemString {
			w.write_string(t.value)
		}
		DataItemNBT {
			w.write_nbt_compound_root(t.value)
		}
		DataItemPos {
			t.value.encode(mut w)
		}
		DataItemInt64 {
			w.write_varint64(t.value)
		}
		DataItemVec3 {
			w.le_f32(t.x)
			w.le_f32(t.y)
			w.le_f32(t.z)
		}
	}
}

pub fn DataItemType.decode(mut r serializer.Reader) !DataItemType {
	d := r.read_varuint32()!
	r.u8()!
	match d {
		0 {
			return DataItemByte{
				value: r.i8()!
			}
		}
		1 {
			return DataItemShort{
				value: r.le_i16()!
			}
		}
		2 {
			return DataItemInt{
				value: r.read_varint32()!
			}
		}
		3 {
			return DataItemFloat{
				value: r.le_f32()!
			}
		}
		4 {
			return DataItemString{
				value: r.read_string()!
			}
		}
		5 {
			return DataItemNBT{
				value: r.read_nbt_compound_root()!
			}
		}
		6 {
			return DataItemPos{
				value: types.BlockPos.decode(mut r)!
			}
		}
		7 {
			return DataItemInt64{
				value: r.read_varint64()!
			}
		}
		8 {
			return DataItemVec3{
				x: r.le_f32()!
				y: r.le_f32()!
				z: r.le_f32()!
			}
		}
		else {
			return error('invalid DataItemType ${d}')
		}
	}
}
