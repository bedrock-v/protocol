module packets

import serializer
import version.v291.types as types_291
import version.v361.types

pub struct StructureBlockUpdatePacket {
pub mut:
	block_position types_291.BlockPosition
	editor_data    types.StructureEditorData
	powered        bool
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
	p.editor_data.encode(mut w)
	w.bool(p.powered)
}

pub fn (mut p StructureBlockUpdatePacket) decode_payload(mut r serializer.Reader) ! {
	p.block_position = types_291.BlockPosition.decode(mut r)!
	p.editor_data = types.StructureEditorData.decode(mut r)!
	p.powered = r.bool()!
}
