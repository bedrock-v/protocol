module serializer

import math

pub struct Writer {
pub mut:
	data []u8
}

pub fn new_writer() Writer {
	return Writer{
		data: []u8{}
	}
}

pub fn (w &Writer) bytes() []u8 {
	return w.data
}

pub fn (mut w Writer) write_raw(b []u8) {
	w.data << b
}

pub fn (mut w Writer) u8(v u8) {
	w.data << v
}

pub fn (mut w Writer) i8(v i8) {
	w.data << u8(v)
}

pub fn (mut w Writer) bool(v bool) {
	w.data << if v { u8(1) } else { u8(0) }
}

pub fn (mut w Writer) le_u16(v u16) {
	w.data << u8(v)
	w.data << u8(v >> 8)
}

pub fn (mut w Writer) le_i16(v i16) {
	w.le_u16(u16(v))
}

pub fn (mut w Writer) be_u16(v u16) {
	w.data << u8(v >> 8)
	w.data << u8(v)
}

pub fn (mut w Writer) be_i16(v i16) {
	w.be_u16(u16(v))
}

pub fn (mut w Writer) le_u32(v u32) {
	w.data << u8(v)
	w.data << u8(v >> 8)
	w.data << u8(v >> 16)
	w.data << u8(v >> 24)
}

pub fn (mut w Writer) le_i32(v i32) {
	w.le_u32(u32(v))
}

pub fn (mut w Writer) be_u32(v u32) {
	w.data << u8(v >> 24)
	w.data << u8(v >> 16)
	w.data << u8(v >> 8)
	w.data << u8(v)
}

pub fn (mut w Writer) be_i32(v i32) {
	w.be_u32(u32(v))
}

pub fn (mut w Writer) le_u64(v u64) {
	for i in 0 .. 8 {
		w.data << u8(v >> (u64(i) * 8))
	}
}

pub fn (mut w Writer) le_i64(v i64) {
	w.le_u64(u64(v))
}

pub fn (mut w Writer) be_u64(v u64) {
	for i := 7; i >= 0; i-- {
		w.data << u8(v >> (u64(i) * 8))
	}
}

pub fn (mut w Writer) be_i64(v i64) {
	w.be_u64(u64(v))
}

pub fn (mut w Writer) le_f32(v f32) {
	w.le_u32(math.f32_bits(v))
}

pub fn (mut w Writer) le_f64(v f64) {
	w.le_u64(math.f64_bits(v))
}

pub fn (mut w Writer) be_f32(v f32) {
	w.be_u32(math.f32_bits(v))
}

pub fn (mut w Writer) write_varuint32(value u32) {
	mut v := value
	for v >= 0x80 {
		w.data << u8(v) | 0x80
		v >>= 7
	}
	w.data << u8(v)
}

pub fn (mut w Writer) write_varint32(value i32) {
	mut ux := u32(value) << 1
	if value < 0 {
		ux = ~ux
	}
	w.write_varuint32(ux)
}

pub fn (mut w Writer) write_varuint64(value u64) {
	mut v := value
	for v >= 0x80 {
		w.data << u8(v) | 0x80
		v >>= 7
	}
	w.data << u8(v)
}

pub fn (mut w Writer) write_varint64(value i64) {
	mut ux := u64(value) << 1
	if value < 0 {
		ux = ~ux
	}
	w.write_varuint64(ux)
}
