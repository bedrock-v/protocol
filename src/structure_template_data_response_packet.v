module protocol

import serializer
import nbt

pub struct StructureTemplateDataResponsePacket {
pub mut:
	structure_template_name string
	has_nbt                 bool
	nbt                     nbt.RootTag
	response_type           u8
}

pub fn (p &StructureTemplateDataResponsePacket) pid() u16 {
	return structure_template_data_response_packet
}

pub fn (p &StructureTemplateDataResponsePacket) name() string {
	return 'StructureTemplateDataResponsePacket'
}

pub fn (p &StructureTemplateDataResponsePacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p StructureTemplateDataResponsePacket) decode_payload(mut r serializer.Reader) ! {
	p.structure_template_name = r.read_string()!
	p.has_nbt = r.bool()!
	if p.has_nbt {
		p.nbt = r.read_nbt_compound_root()!
	}
	p.response_type = r.u8()!
}

pub fn (p &StructureTemplateDataResponsePacket) encode_payload(mut w serializer.Writer) {
	w.write_string(p.structure_template_name)
	w.bool(p.has_nbt)
	if p.has_nbt {
		w.write_nbt_compound_root(p.nbt)
	}
	w.u8(p.response_type)
}
