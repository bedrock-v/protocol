module packets

import serializer
import version.v291.types

pub enum StructureBlockType as u32 {
	data    = 0
	save    = 1
	load    = 2
	corner  = 3
	invalid = 4
	export  = 5
}

pub enum StructureMirror as u32 {
	@none = 0
	x     = 1
	z     = 2
	xz    = 3
}

pub enum StructureRotation as u32 {
	@none      = 0
	rotate_90  = 1
	rotate_180 = 2
	rotate_270 = 3
}

pub struct StructureBlockUpdatePacket {
pub mut:
	block_position       types.BlockPosition
	structure_type       StructureBlockType
	structure_name       string
	data_field           string
	offset               types.BlockPosition
	size                 types.BlockPosition
	including_players    bool
	ignoring_blocks      bool
	integrity_value      f32
	integrity_seed       u32
	mirror               StructureMirror
	rotation             StructureRotation
	ignoring_entities    bool
	bounding_box_visible bool
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
	w.write_varuint32(u32(p.structure_type))
	w.write_string(p.structure_name)
	w.write_string(p.structure_name)
	p.offset.encode(mut w)
	p.size.encode(mut w)
	w.bool(!p.ignoring_entities)
	w.bool(p.ignoring_blocks)
	w.bool(p.including_players)
	w.bool(false)
	w.le_f32(p.integrity_value)
	w.write_varuint32(p.integrity_seed)
	w.write_varuint32(u32(p.mirror))
	w.write_varuint32(u32(p.rotation))
	w.bool(p.ignoring_entities)
	w.bool(true)
	min := types.Vector3i{
		x: p.block_position.x + p.offset.x
		y: i32(p.block_position.y) + i32(p.offset.y)
		z: p.block_position.z + p.offset.z
	}
	min.encode(mut w)
	max := types.Vector3i{
		x: min.x + p.size.x
		y: min.y + i32(p.size.y)
		z: min.z + p.size.z
	}
	max.encode(mut w)
	w.bool(p.bounding_box_visible)
	w.bool(p.powered)
}

pub fn (mut p StructureBlockUpdatePacket) decode_payload(mut r serializer.Reader) ! {
	p.block_position = types.BlockPosition.decode(mut r)!
	p.structure_type = unsafe { StructureBlockType(r.read_varuint32()!) }
	p.structure_name = r.read_string()!
	p.data_field = r.read_string()!
	p.offset = types.BlockPosition.decode(mut r)!
	p.size = types.BlockPosition.decode(mut r)!
	r.bool()!
	p.ignoring_blocks = !r.bool()!
	p.including_players = r.bool()!
	r.bool()!
	p.integrity_value = r.le_f32()!
	p.integrity_seed = r.read_varuint32()!
	p.mirror = unsafe { StructureMirror(r.read_varuint32()!) }
	p.rotation = unsafe { StructureRotation(r.read_varuint32()!) }
	p.ignoring_entities = r.bool()!
	r.bool()!
	types.Vector3i.decode(mut r)!
	types.Vector3i.decode(mut r)!
	p.bounding_box_visible = r.bool()!
	p.powered = r.bool()!
}
