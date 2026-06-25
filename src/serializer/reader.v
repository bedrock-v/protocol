module serializer

import math

pub struct Reader {
pub:
	data []u8
pub mut:
	offset int
}

pub fn new_reader(data []u8) Reader {
	return Reader{
		data: data
	}
}

pub fn (r &Reader) remaining() int {
	return r.data.len - r.offset
}

fn (mut r Reader) need(n int) ! {
	if r.offset + n > r.data.len {
		return error('unexpected end of buffer: need ${n} bytes at offset ${r.offset}, have ${r.data.len}')
	}
}

pub fn (mut r Reader) read_raw(n int) ![]u8 {
	r.need(n)!
	out := r.data[r.offset..r.offset + n].clone()
	r.offset += n
	return out
}

pub fn (mut r Reader) u8() !u8 {
	r.need(1)!
	b := r.data[r.offset]
	r.offset++
	return b
}

pub fn (mut r Reader) i8() !i8 {
	return i8(r.u8()!)
}

pub fn (mut r Reader) bool() !bool {
	return r.u8()! != 0
}

pub fn (mut r Reader) le_u16() !u16 {
	r.need(2)!
	v := u16(r.data[r.offset]) | (u16(r.data[r.offset + 1]) << 8)
	r.offset += 2
	return v
}

pub fn (mut r Reader) le_i16() !i16 {
	return i16(r.le_u16()!)
}

pub fn (mut r Reader) be_u16() !u16 {
	r.need(2)!
	v := (u16(r.data[r.offset]) << 8) | u16(r.data[r.offset + 1])
	r.offset += 2
	return v
}

pub fn (mut r Reader) be_i16() !i16 {
	return i16(r.be_u16()!)
}

pub fn (mut r Reader) le_u32() !u32 {
	r.need(4)!
	v := u32(r.data[r.offset]) | (u32(r.data[r.offset + 1]) << 8) | (u32(r.data[r.offset + 2]) << 16) | (u32(r.data[r.offset + 3]) << 24)
	r.offset += 4
	return v
}

pub fn (mut r Reader) le_i32() !i32 {
	return i32(r.le_u32()!)
}

pub fn (mut r Reader) be_u32() !u32 {
	r.need(4)!
	v := (u32(r.data[r.offset]) << 24) | (u32(r.data[r.offset + 1]) << 16) | (u32(r.data[r.offset + 2]) << 8) | u32(r.data[r.offset + 3])
	r.offset += 4
	return v
}

pub fn (mut r Reader) be_i32() !i32 {
	return i32(r.be_u32()!)
}

pub fn (mut r Reader) le_u64() !u64 {
	r.need(8)!
	mut v := u64(0)
	for i in 0 .. 8 {
		v |= u64(r.data[r.offset + i]) << (u64(i) * 8)
	}
	r.offset += 8
	return v
}

pub fn (mut r Reader) le_i64() !i64 {
	return i64(r.le_u64()!)
}

pub fn (mut r Reader) be_u64() !u64 {
	r.need(8)!
	mut v := u64(0)
	for i in 0 .. 8 {
		v = (v << 8) | u64(r.data[r.offset + i])
	}
	r.offset += 8
	return v
}

pub fn (mut r Reader) be_i64() !i64 {
	return i64(r.be_u64()!)
}

pub fn (mut r Reader) le_f32() !f32 {
	return math.f32_from_bits(r.le_u32()!)
}

pub fn (mut r Reader) le_f64() !f64 {
	return math.f64_from_bits(r.le_u64()!)
}

pub fn (mut r Reader) be_f32() !f32 {
	return math.f32_from_bits(r.be_u32()!)
}

pub fn (mut r Reader) read_varuint32() !u32 {
	mut value := u32(0)
	mut shift := u32(0)
	for shift < 35 {
		b := r.u8()!
		value |= u32(b & 0x7f) << shift
		if b & 0x80 == 0 {
			return value
		}
		shift += 7
	}
	return error('varuint32 did not terminate after 5 bytes')
}

pub fn (mut r Reader) read_varint32() !i32 {
	ux := r.read_varuint32()!
	mut x := i32(ux >> 1)
	if ux & 1 != 0 {
		x = ~x
	}
	return x
}

pub fn (mut r Reader) read_varuint64() !u64 {
	mut value := u64(0)
	mut shift := u64(0)
	for shift < 70 {
		b := r.u8()!
		value |= u64(b & 0x7f) << shift
		if b & 0x80 == 0 {
			return value
		}
		shift += 7
	}
	return error('varuint64 did not terminate after 10 bytes')
}

pub fn (mut r Reader) read_varint64() !i64 {
	ux := r.read_varuint64()!
	mut x := i64(ux >> 1)
	if ux & 1 != 0 {
		x = ~x
	}
	return x
}
