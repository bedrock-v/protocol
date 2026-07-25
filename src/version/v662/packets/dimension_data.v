module packets

import serializer
import version.v662.types

pub struct DimensionDataPacket {
pub mut:
	dimension_definition_group types.DimensionDefinitionGroup
}

pub fn (p &DimensionDataPacket) pid() u16 { return 180 }

pub fn (p &DimensionDataPacket) name() string { return 'DimensionDataPacket' }

pub fn (p &DimensionDataPacket) can_be_sent_before_login() bool { return false }

pub fn (p &DimensionDataPacket) encode_payload(mut w serializer.Writer) {
	p.dimension_definition_group.encode(mut w)
}

pub fn (mut p DimensionDataPacket) decode_payload(mut r serializer.Reader) ! {
	p.dimension_definition_group = types.DimensionDefinitionGroup.decode(mut r)!
}
