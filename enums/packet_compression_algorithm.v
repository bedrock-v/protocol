module enums

import protocol.serializer

pub enum PacketCompressionAlgorithm as u16 {
	z_lib  = 0
	snappy = 1
	@none  = 0xffff
}

pub fn (e PacketCompressionAlgorithm) encode(mut w serializer.Writer) {
	w.le_u16(u16(e))
}

pub fn PacketCompressionAlgorithm.decode(mut r serializer.Reader) !PacketCompressionAlgorithm {
	return unsafe { PacketCompressionAlgorithm(r.le_u16()!) }
}
