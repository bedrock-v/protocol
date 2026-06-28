module protocol

import serializer
import types

pub struct StructureBlockUpdatePacket {
pub mut:
	block_position        types.BlockPosition
	structure_editor_data types.StructureEditorData
	is_powered            bool
	waterlogged           bool
}

pub fn (p &StructureBlockUpdatePacket) pid() u16 {
	return structure_block_update_packet
}

pub fn (p &StructureBlockUpdatePacket) name() string {
	return 'StructureBlockUpdatePacket'
}

pub fn (p &StructureBlockUpdatePacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p StructureBlockUpdatePacket) decode_payload(mut r serializer.Reader) ! {
	p.block_position = r.read_block_position()!
	p.structure_editor_data = r.read_structure_editor_data()!
	p.is_powered = r.bool()!
	p.waterlogged = r.bool()!
}

pub fn (p &StructureBlockUpdatePacket) encode_payload(mut w serializer.Writer) {
	w.write_block_position(p.block_position)
	w.write_structure_editor_data(p.structure_editor_data)
	w.bool(p.is_powered)
	w.bool(p.waterlogged)
}
