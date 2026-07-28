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

fn read_v662_stack_user_data_blob(data []u8) ![]u8 {
	mut r := serializer.new_reader(data)
	id := r.read_varint32()!
	if id == 0 {
		return []u8{}
	}
	r.le_u16()!
	r.read_varuint32()!
	if r.bool()! {
		r.read_varint32()!
	}
	r.read_varint32()!
	return r.read_string_bytes()!
}

fn read_v662_instance_user_data_blob(data []u8) ![]u8 {
	mut r := serializer.new_reader(data)
	id := r.read_varint32()!
	if id == 0 {
		return []u8{}
	}
	r.le_u16()!
	r.read_varuint32()!
	r.read_varint32()!
	return r.read_string_bytes()!
}

fn stack_bytes_with_extra_blob(extra_blob []u8) []u8 {
	mut w := serializer.new_writer()
	w.write_varint32(5)
	w.le_u16(2)
	w.write_varuint32(0)
	w.bool(false)
	w.write_varint32(11)
	w.write_string_bytes(extra_blob)
	return w.bytes()
}

fn decode_stack_descriptor(data []u8) !NetworkItemStackDescriptor {
	mut r := serializer.new_reader(data)
	return NetworkItemStackDescriptor.decode(mut r)
}

fn decode_instance_descriptor(data []u8) !NetworkItemInstanceDescriptor {
	mut r := serializer.new_reader(data)
	return NetworkItemInstanceDescriptor.decode(mut r)
}

fn instance_bytes_with_extra_blob(extra_blob []u8) []u8 {
	mut w := serializer.new_writer()
	w.write_varint32(5)
	w.le_u16(2)
	w.write_varuint32(0)
	w.write_varint32(11)
	w.write_string_bytes(extra_blob)
	return w.bytes()
}

fn test_v662_stack_descriptor_writes_structured_empty_extra_data() {
	mut w := serializer.new_writer()

	NetworkItemStackDescriptor{
		id:               5
		stack_size:       2
		block_runtime_id: 11
	}.encode(mut w)
	assert read_v662_stack_user_data_blob(w.bytes())! == structured_extra_data([])
}

fn test_v662_stack_descriptor_decodes_empty_extra_data_forms() {
	assert decode_stack_descriptor(stack_bytes_with_extra_blob([]))!.user_data_buffer == []
	assert decode_stack_descriptor(stack_bytes_with_extra_blob(structured_extra_data([])))!.user_data_buffer == []
}

fn test_v662_stack_descriptor_roundtrips_raw_extra_data() {
	raw := [u8(0x0a), 0x00, 0x03, 0x66, 0x6f, 0x6f]
	bytes := stack_bytes_with_extra_blob(structured_extra_data(raw))
	decoded := decode_stack_descriptor(bytes)!
	assert decoded.user_data_buffer == raw

	mut w := serializer.new_writer()
	decoded.encode(mut w)
	assert read_v662_stack_user_data_blob(w.bytes())! == structured_extra_data(raw)
}

fn test_v662_instance_descriptor_writes_and_reads_structured_extra_data() {
	mut w := serializer.new_writer()

	NetworkItemInstanceDescriptor{
		id:               5
		stack_size:       2
		block_runtime_id: 11
	}.encode(mut w)
	assert read_v662_instance_user_data_blob(w.bytes())! == structured_extra_data([])

	raw := [u8(0x0a), 0x00, 0x03, 0x62, 0x61, 0x72]
	decoded :=
		decode_instance_descriptor(instance_bytes_with_extra_blob(structured_extra_data(raw)))!
	assert decoded.user_data_buffer == raw
}
