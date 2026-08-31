module packets

import protocol.serializer
import bedrock_v.nbt

pub enum StructureTemplateResponseType as u8 {
	@none   = 0
	export  = 1
	query   = 2
	@import = 3
}

pub struct StructureTemplateDataResponsePacket {
pub mut:
	structure_name string
	save           bool
	structure_nbt  nbt.RootTag
	response_type  StructureTemplateResponseType
}

pub fn (p &StructureTemplateDataResponsePacket) pid() u16 {
	return 133
}

pub fn (p &StructureTemplateDataResponsePacket) name() string {
	return 'StructureTemplateDataResponsePacket'
}

pub fn (p &StructureTemplateDataResponsePacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &StructureTemplateDataResponsePacket) encode_payload(mut w serializer.Writer) {
	w.write_string(p.structure_name)
	w.bool(p.save)
	if p.save {
		w.write_nbt_compound_root(p.structure_nbt)
	}
	w.u8(u8(p.response_type))
}

pub fn (mut p StructureTemplateDataResponsePacket) decode_payload(mut r serializer.Reader) ! {
	p.structure_name = r.read_string()!
	p.save = r.bool()!
	if p.save {
		p.structure_nbt = r.read_nbt_compound_root()!
	}
	p.response_type = unsafe { StructureTemplateResponseType(r.u8()!) }
}
