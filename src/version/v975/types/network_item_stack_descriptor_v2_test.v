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

fn read_v975_user_data_blob(data []u8) ![]u8 {
	mut r := serializer.new_reader(data)
	r.le_i16()!
	r.le_u16()!
	r.read_varuint32()!
	if r.bool()! {
		ItemStackNetIdVariant.decode(mut r)!
	}
	r.read_varuint32()!
	count := int(r.read_varuint32()!)
	return r.read_raw(count)!
}

fn v975_bytes_with_extra_blob(extra_blob []u8) []u8 {
	mut w := serializer.new_writer()
	w.le_i16(5)
	w.le_u16(2)
	w.write_varuint32(0)
	w.bool(false)
	w.write_varuint32(11)
	w.write_varuint32(u32(extra_blob.len))
	w.write_raw(extra_blob)
	return w.bytes()
}

fn decode_v975_descriptor(data []u8) !NetworkItemStackDescriptorV2 {
	mut r := serializer.new_reader(data)
	return NetworkItemStackDescriptorV2.decode(mut r)
}

fn test_v975_descriptor_writes_structured_empty_extra_data() {
	mut w := serializer.new_writer()

	NetworkItemStackDescriptorV2{
		id:               5
		stack_size:       2
		block_runtime_id: 11
	}.encode(mut w)
	assert read_v975_user_data_blob(w.bytes())! == structured_extra_data([])
}

fn test_v975_descriptor_decodes_empty_extra_data_forms() {
	assert decode_v975_descriptor(v975_bytes_with_extra_blob([]))!.user_data_buffer == []
	assert decode_v975_descriptor(v975_bytes_with_extra_blob(structured_extra_data([])))!.user_data_buffer == []
}

fn test_v975_descriptor_roundtrips_raw_extra_data() {
	raw := [u8(0x0a), 0x00, 0x03, 0x66, 0x6f, 0x6f]
	decoded := decode_v975_descriptor(v975_bytes_with_extra_blob(structured_extra_data(raw)))!
	assert decoded.user_data_buffer == raw

	mut w := serializer.new_writer()
	decoded.encode(mut w)
	assert read_v975_user_data_blob(w.bytes())! == structured_extra_data(raw)
}
