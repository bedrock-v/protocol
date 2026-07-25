module enums

import serializer

pub enum PacketViolationType as i32 {
	unknown          = -1
	packet_malformed = 0
}

pub fn (e PacketViolationType) encode(mut w serializer.Writer) {
	w.write_varint32(i32(e))
}

pub fn PacketViolationType.decode(mut r serializer.Reader) !PacketViolationType {
	return unsafe { PacketViolationType(r.read_varint32()!) }
}
