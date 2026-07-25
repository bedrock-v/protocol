module packets

import serializer
import version.v662.types

pub struct RemoveVolumeEntityPacket {
pub mut:
	entity_network_id types.EntityNetID
	dimension_type    i32
}

pub fn (p &RemoveVolumeEntityPacket) pid() u16 { return 167 }

pub fn (p &RemoveVolumeEntityPacket) name() string { return 'RemoveVolumeEntityPacket' }

pub fn (p &RemoveVolumeEntityPacket) can_be_sent_before_login() bool { return false }

pub fn (p &RemoveVolumeEntityPacket) encode_payload(mut w serializer.Writer) {
	p.entity_network_id.encode(mut w)
	w.write_varint32(p.dimension_type)
}

pub fn (mut p RemoveVolumeEntityPacket) decode_payload(mut r serializer.Reader) ! {
	p.entity_network_id = types.EntityNetID.decode(mut r)!
	p.dimension_type = r.read_varint32()!
}
