module packets

import protocol.serializer

pub struct RemoveVolumeEntityPacket {
pub mut:
	id        u32
	dimension i32
}

pub fn (p &RemoveVolumeEntityPacket) pid() u16 {
	return 167
}

pub fn (p &RemoveVolumeEntityPacket) name() string {
	return 'RemoveVolumeEntityPacket'
}

pub fn (p &RemoveVolumeEntityPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &RemoveVolumeEntityPacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint32(p.id)
	w.write_varint32(p.dimension)
}

pub fn (mut p RemoveVolumeEntityPacket) decode_payload(mut r serializer.Reader) ! {
	p.id = r.read_varuint32()!
	p.dimension = r.read_varint32()!
}
