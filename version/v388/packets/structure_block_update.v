module packets

import protocol.serializer
import protocol.version.v291.types as types_291
import protocol.version.v388.types

pub enum StructureBlockType as i32 {
	data    = 0
	save    = 1
	load    = 2
	corner  = 3
	invalid = 4
	export  = 5
}

pub enum StructureRedstoneSaveMode as i32 {
	saves_to_memory = 0
	saves_to_disk   = 1
}

pub struct StructureBlockUpdatePacket {
pub mut:
	block_position       types_291.BlockPosition
	structure_name       string
	data_field           string
	including_players    bool
	bounding_box_visible bool
	structure_type       StructureBlockType
	settings             types.StructureSettings
	redstone_save_mode   StructureRedstoneSaveMode
	powered              bool
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
	w.bool(p.including_players)
	w.bool(p.bounding_box_visible)
	w.write_varint32(i32(p.structure_type))
	p.settings.encode(mut w)
	w.write_varint32(i32(p.redstone_save_mode))
	w.bool(p.powered)
}

pub fn (mut p StructureBlockUpdatePacket) decode_payload(mut r serializer.Reader) ! {
	p.block_position = types_291.BlockPosition.decode(mut r)!
	p.structure_name = r.read_string()!
	p.data_field = r.read_string()!
	p.including_players = r.bool()!
	p.bounding_box_visible = r.bool()!
	p.structure_type = unsafe { StructureBlockType(r.read_varint32()!) }
	p.settings = types.StructureSettings.decode(mut r)!
	p.redstone_save_mode = unsafe { StructureRedstoneSaveMode(r.read_varint32()!) }
	p.powered = r.bool()!
}
