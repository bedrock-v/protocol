module packets

import serializer
import version.v2168.types
import version.v944.types as types_944

pub struct StructureBlockUpdatePacket {
pub mut:
	block_position types_944.NetworkBlockPosition
	structure_data types.StructureEditorData
	trigger        bool
	is_waterlogged bool
}

pub fn (p &StructureBlockUpdatePacket) pid() u16 { return 90 }

pub fn (p &StructureBlockUpdatePacket) name() string { return 'StructureBlockUpdatePacket' }

pub fn (p &StructureBlockUpdatePacket) can_be_sent_before_login() bool { return false }

pub fn (p &StructureBlockUpdatePacket) encode_payload(mut w serializer.Writer) {
	p.block_position.encode(mut w)
	p.structure_data.encode(mut w)
	w.bool(p.trigger)
	w.bool(p.is_waterlogged)
}

pub fn (mut p StructureBlockUpdatePacket) decode_payload(mut r serializer.Reader) ! {
	p.block_position = types_944.NetworkBlockPosition.decode(mut r)!
	p.structure_data = types.StructureEditorData.decode(mut r)!
	p.trigger = r.bool()!
	p.is_waterlogged = r.bool()!
}
