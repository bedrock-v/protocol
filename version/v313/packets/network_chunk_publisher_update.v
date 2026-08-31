module packets

import protocol.serializer
import protocol.version.v291.types

pub struct NetworkChunkPublisherUpdatePacket {
pub mut:
	position types.Vector3i
	radius   u32
}

pub fn (p &NetworkChunkPublisherUpdatePacket) pid() u16 {
	return 121
}

pub fn (p &NetworkChunkPublisherUpdatePacket) name() string {
	return 'NetworkChunkPublisherUpdatePacket'
}

pub fn (p &NetworkChunkPublisherUpdatePacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &NetworkChunkPublisherUpdatePacket) encode_payload(mut w serializer.Writer) {
	p.position.encode(mut w)
	w.write_varuint32(p.radius)
}

pub fn (mut p NetworkChunkPublisherUpdatePacket) decode_payload(mut r serializer.Reader) ! {
	p.position = types.Vector3i.decode(mut r)!
	p.radius = r.read_varuint32()!
}
