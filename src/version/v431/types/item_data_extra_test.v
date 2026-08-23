module types

import protocol.serializer

fn structured_extra_data(raw []u8) []u8 {
	mut inner := serializer.new_writer()
	if raw.len == 0 {
		inner.le_i16(0)
	} else {
		inner.le_i16(-1)
		inner.u8(1)
		inner.write_raw(raw)
	}
	inner.write_varuint32(0)
	inner.write_varuint32(0)
	return inner.bytes()
}

fn read_v431_user_data_blob(data []u8, has_net_id bool) ![]u8 {
	mut r := serializer.new_reader(data)
	id := r.read_varint32()!
	if id == 0 {
		return []u8{}
	}
	r.le_u16()!
	r.read_varuint32()!
	if has_net_id {
		r.bool()!
	}
	r.read_varint32()!
	count := r.read_count()!
	return r.read_raw(count)!
}

fn item_data_bytes_with_extra_blob(extra_blob []u8) []u8 {
	mut w := serializer.new_writer()
	w.write_varint32(5)
	w.le_u16(2)
	w.write_varuint32(0)
	w.bool(false)
	w.write_varint32(11)
	w.write_varuint32(u32(extra_blob.len))
	w.write_raw(extra_blob)
	return w.bytes()
}

fn decode_item_data(data []u8) !ItemData {
	mut r := serializer.new_reader(data)
	return ItemData.decode(mut r)
}

fn test_v431_item_data_writes_structured_empty_extra_data() {
	mut w := serializer.new_writer()

	ItemData{
		runtime_id:       5
		count:            2
		block_runtime_id: 11
	}.encode(mut w)
	assert read_v431_user_data_blob(w.bytes(), true)! == structured_extra_data([])
}

fn test_v431_item_data_decodes_empty_extra_data_forms() {
	assert decode_item_data(item_data_bytes_with_extra_blob([]))!.user_data == []
	assert decode_item_data(item_data_bytes_with_extra_blob(structured_extra_data([])))!.user_data == []
}

fn test_v431_item_data_roundtrips_raw_extra_data() {
	raw := [u8(0x0a), 0x00, 0x03, 0x66, 0x6f, 0x6f]
	decoded := decode_item_data(item_data_bytes_with_extra_blob(structured_extra_data(raw)))!
	assert decoded.user_data == raw

	mut w := serializer.new_writer()
	decoded.encode(mut w)
	assert read_v431_user_data_blob(w.bytes(), true)! == structured_extra_data(raw)
}
