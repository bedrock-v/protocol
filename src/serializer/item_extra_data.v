module serializer

// The user data buffer is a little-endian substream: the canPlace and
// canBreak list counts are fixed le i32 values, not varints.
pub fn (mut w Writer) write_item_extra_data(raw []u8) {
	w.write_item_extra_data_opts(raw, false)
}

// blocking must be true for items the client expects blocking ticks for
// (minecraft:shield), which append a trailing le i64 to the buffer.
pub fn (mut w Writer) write_item_extra_data_opts(raw []u8, blocking bool) {
	mut inner := new_writer()
	if raw.len == 0 {
		inner.le_i16(0)
	} else {
		inner.le_i16(-1)
		inner.u8(1)
		inner.write_raw(raw)
	}
	inner.le_i32(0)
	inner.le_i32(0)
	if blocking {
		inner.le_i64(0)
	}
	w.write_string_bytes(inner.bytes())
}

pub fn (mut r Reader) read_item_extra_data() ![]u8 {
	buf := r.read_string_bytes()!
	if buf.len == 0 {
		return []u8{}
	}
	mut inner := new_reader(buf)
	marker := inner.le_i16()!
	mut raw := []u8{}
	if marker == -1 {
		inner.u8()!
		if inner.remaining() >= 8 {
			raw = inner.read_raw(inner.remaining() - 8)!
		}
	}
	return raw
}
