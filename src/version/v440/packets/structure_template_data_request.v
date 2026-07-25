module packets

import serializer
import version.v440.types
import version.v291.types as types_291

pub enum StructureTemplateRequestOperation as u8 {
	@none                  = 0
	export_from_saved_mode = 1
	export_from_load_mode  = 2
	query_saved_structure  = 3
}

pub struct StructureTemplateDataRequestPacket {
pub mut:
	structure_name string
	position       types_291.BlockPosition
	settings       types.StructureSettings
	operation      StructureTemplateRequestOperation
}

pub fn (p &StructureTemplateDataRequestPacket) pid() u16 {
	return 132
}

pub fn (p &StructureTemplateDataRequestPacket) name() string {
	return 'StructureTemplateDataRequestPacket'
}

pub fn (p &StructureTemplateDataRequestPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &StructureTemplateDataRequestPacket) encode_payload(mut w serializer.Writer) {
	w.write_string(p.structure_name)
	p.position.encode(mut w)
	p.settings.encode(mut w)
	w.u8(u8(p.operation))
}

pub fn (mut p StructureTemplateDataRequestPacket) decode_payload(mut r serializer.Reader) ! {
	p.structure_name = r.read_string()!
	p.position = types_291.BlockPosition.decode(mut r)!
	p.settings = types.StructureSettings.decode(mut r)!
	p.operation = unsafe { StructureTemplateRequestOperation(r.u8()!) }
}
