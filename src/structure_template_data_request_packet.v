module src

import src.serializer
import src.types

pub struct StructureTemplateDataRequestPacket {
pub mut:
	structure_template_name string
	structure_block_position types.BlockPosition
	structure_settings      types.StructureSettings
	request_type            u8
}

pub fn (p &StructureTemplateDataRequestPacket) pid() u16 {
	return structure_template_data_request_packet
}

pub fn (p &StructureTemplateDataRequestPacket) name() string {
	return 'StructureTemplateDataRequestPacket'
}

pub fn (p &StructureTemplateDataRequestPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p StructureTemplateDataRequestPacket) decode_payload(mut r serializer.Reader) ! {
	p.structure_template_name = r.read_string()!
	p.structure_block_position = r.read_block_position()!
	p.structure_settings = r.read_structure_settings()!
	p.request_type = r.u8()!
}

pub fn (p &StructureTemplateDataRequestPacket) encode_payload(mut w serializer.Writer) {
	w.write_string(p.structure_template_name)
	w.write_block_position(p.structure_block_position)
	w.write_structure_settings(p.structure_settings)
	w.u8(p.request_type)
}
