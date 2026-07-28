module packets

import protocol.serializer

pub struct FullChunkDataPacket {
pub mut:
	data []u8
}

pub fn (p &FullChunkDataPacket) pid() u16 {
	return 0xba
}

pub fn (p &FullChunkDataPacket) name() string {
	return 'FullChunkDataPacket'
}

pub fn (p &FullChunkDataPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &FullChunkDataPacket) encode_payload(mut w serializer.Writer) {
	w.write_raw(p.data)
}

pub fn (mut p FullChunkDataPacket) decode_payload(mut r serializer.Reader) ! {
	p.data = r.read_raw(r.remaining())!
}
