module serializer

fn test_read_count_rejects_a_length_past_the_end_of_the_buffer() {
	// 0xffffffff as a varuint32, followed by nothing to read.
	mut r := new_reader([u8(0xff), 0xff, 0xff, 0xff, 0x0f])
	if _ := r.read_count() {
		assert false, 'expected an out of range list length to be rejected'
	}
}

fn test_read_count_accepts_a_length_the_buffer_can_hold() {
	mut r := new_reader([u8(0x02), 0x01, 0x02])
	assert r.read_count()! == 2
}

fn test_prealloc_bounds_the_reserved_capacity() {
	assert prealloc(8) == 8
	assert prealloc(-1) == 0
	assert prealloc(max_prealloc + 1) == max_prealloc
}
