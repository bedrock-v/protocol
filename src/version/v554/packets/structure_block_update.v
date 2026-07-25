module packets

import serializer
import version.v291.types as types_291
import version.v503.types as types_503

pub struct StructureBlockUpdatePacket {
pub mut:
	block_position       types_291.BlockPosition
	structure_name       string
	data_field           string
	include_players      bool
	show_bounding_box    bool
	structure_block_type i32
	settings             types_503.StructureSettings
	redstone_save_mode   i32
	powered              bool
	waterlogged          bool
}

pub fn (p &StructureBlockUpdatePacket) pid() u16 {
	return 90
}

pub fn (p &StructureBlockUpdatePacket) name() string {
	return 'StructureBlockUpdatePacket'
}

pub fn (p &StructureBlockUpdatePacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &StructureBlockUpdatePacket) encode_payload(mut w serializer.Writer) {
	p.block_position.encode(mut w)
	w.write_string(p.structure_name)
	w.write_string(p.data_field)
	w.bool(p.include_players)
	w.bool(p.show_bounding_box)
	w.write_varint32(p.structure_block_type)
	p.settings.encode(mut w)
	w.write_varint32(p.redstone_save_mode)
	w.bool(p.powered)
	w.bool(p.waterlogged)
}

pub fn (mut p StructureBlockUpdatePacket) decode_payload(mut r serializer.Reader) ! {
	p.block_position = types_291.BlockPosition.decode(mut r)!
	p.structure_name = r.read_string()!
	p.data_field = r.read_string()!
	p.include_players = r.bool()!
	p.show_bounding_box = r.bool()!
	p.structure_block_type = r.read_varint32()!
	p.settings = types_503.StructureSettings.decode(mut r)!
	p.redstone_save_mode = r.read_varint32()!
	p.powered = r.bool()!
	p.waterlogged = r.bool()!
}
