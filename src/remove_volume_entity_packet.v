module src

import src.serializer

pub struct RemoveVolumeEntityPacket {
pub mut:
	entity_net_id int
	dimension     int
}

pub fn (p &RemoveVolumeEntityPacket) pid() u16 {
	return remove_volume_entity_packet
}

pub fn (p &RemoveVolumeEntityPacket) name() string {
	return 'RemoveVolumeEntityPacket'
}

pub fn (p &RemoveVolumeEntityPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p RemoveVolumeEntityPacket) decode_payload(mut r serializer.Reader) ! {
	p.entity_net_id = int(r.read_varuint32()!)
	p.dimension = int(r.read_varint32()!)
}

pub fn (p &RemoveVolumeEntityPacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint32(u32(p.entity_net_id))
	w.write_varint32(i32(p.dimension))
}
