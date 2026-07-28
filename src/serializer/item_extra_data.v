module serializer

pub fn (mut w Writer) write_item_extra_data(raw []u8) {
	mut inner := new_writer()
	if raw.len == 0 {
		inner.le_i16(0)
	} else {
		inner.le_i16(-1)
		inner.u8(1)
		inner.write_raw(raw)
	}
	inner.write_varuint32(0)
	inner.write_varuint32(0)
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
		if inner.remaining() >= 2 {
			raw = inner.read_raw(inner.remaining() - 2)!
		}
	}
	return raw
}
