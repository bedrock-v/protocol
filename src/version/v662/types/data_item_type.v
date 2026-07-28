module types

import protocol.serializer
import nbt

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
	value BlockPos
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

pub fn (t DataItemType) encode(mut w serializer.Writer) {
	match t {
		DataItemByte {
			w.i8(0)
			w.i8(t.value)
		}
		DataItemShort {
			w.i8(1)
			w.le_i16(t.value)
		}
		DataItemInt {
			w.i8(2)
			w.write_varint32(t.value)
		}
		DataItemFloat {
			w.i8(3)
			w.le_f32(t.value)
		}
		DataItemString {
			w.i8(4)
			w.write_string(t.value)
		}
		DataItemNBT {
			w.i8(5)
			w.write_nbt_compound_root(t.value)
		}
		DataItemPos {
			w.i8(6)
			t.value.encode(mut w)
		}
		DataItemInt64 {
			w.i8(7)
			w.write_varint64(t.value)
		}
		DataItemVec3 {
			w.i8(8)
			w.le_f32(t.x)
			w.le_f32(t.y)
			w.le_f32(t.z)
		}
	}
}

pub fn DataItemType.decode(mut r serializer.Reader) !DataItemType {
	d := r.i8()!
	match d {
		0 { return DataItemByte{
				value: r.i8()!
			} }
		1 { return DataItemShort{
				value: r.le_i16()!
			} }
		2 { return DataItemInt{
				value: r.read_varint32()!
			} }
		3 { return DataItemFloat{
				value: r.le_f32()!
			} }
		4 { return DataItemString{
				value: r.read_string()!
			} }
		5 { return DataItemNBT{
				value: r.read_nbt_compound_root()!
			} }
		6 { return DataItemPos{
				value: BlockPos.decode(mut r)!
			} }
		7 { return DataItemInt64{
				value: r.read_varint64()!
			} }
		8 { return DataItemVec3{
				x: r.le_f32()!
				y: r.le_f32()!
				z: r.le_f32()!
			} }
		else { return error('invalid DataItemType ${d}') }
	}
}
