module enums

import protocol.serializer

pub enum ObjectiveSortOrder as i32 {
	ascending  = 0
	descending = 1
}

pub fn (e ObjectiveSortOrder) encode(mut w serializer.Writer) {
	w.write_varint32(i32(e))
}

pub fn ObjectiveSortOrder.decode(mut r serializer.Reader) !ObjectiveSortOrder {
	return unsafe { ObjectiveSortOrder(r.read_varint32()!) }
}
