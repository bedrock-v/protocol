module packets

import protocol.serializer
import bedrock_v.nbt

pub struct StructureTemplateDataResponsePacket {
pub mut:
	name string
	save bool
	tag  nbt.RootTag
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
	w.write_string(p.name)
	w.bool(p.save)
	if p.save {
		w.write_nbt_compound_root(p.tag)
	}
}

pub fn (mut p StructureTemplateDataResponsePacket) decode_payload(mut r serializer.Reader) ! {
	p.name = r.read_string()!
	p.save = r.bool()!
	if p.save {
		p.tag = r.read_nbt_compound_root()!
	}
}
