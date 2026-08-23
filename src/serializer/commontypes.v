module serializer

pub fn (mut r Reader) read_string() !string {
	length := r.read_count()!
	return r.read_raw(length)!.bytestr()
}

pub fn (mut w Writer) write_string(v string) {
	w.write_varuint32(u32(v.len))
	w.write_raw(v.bytes())
}

pub fn (mut r Reader) read_string_bytes() ![]u8 {
	length := r.read_count()!
	return r.read_raw(length)!
}

pub fn (mut w Writer) write_string_bytes(v []u8) {
	w.write_varuint32(u32(v.len))
	w.write_raw(v)
}
