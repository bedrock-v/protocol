module enums

import protocol.serializer

pub enum PacketViolationSeverity as i32 {
	unknown                = -1
	warning                = 0
	final_warning          = 1
	terminating_connection = 2
}

pub fn (e PacketViolationSeverity) encode(mut w serializer.Writer) {
	w.write_varint32(i32(e))
}

pub fn PacketViolationSeverity.decode(mut r serializer.Reader) !PacketViolationSeverity {
	return unsafe { PacketViolationSeverity(r.read_varint32()!) }
}
