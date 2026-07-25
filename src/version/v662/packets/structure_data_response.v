module packets

import serializer
import nbt
import version.v662.enums

pub struct StructureDataResponsePacket {
pub mut:
	structure_name string
	has_nbt        bool
	structure_nbt  nbt.RootTag
	response_type  enums.StructureTemplateResponseType
}

pub fn (p &StructureDataResponsePacket) pid() u16 { return 133 }

pub fn (p &StructureDataResponsePacket) name() string { return 'StructureDataResponsePacket' }

pub fn (p &StructureDataResponsePacket) can_be_sent_before_login() bool { return false }

pub fn (p &StructureDataResponsePacket) encode_payload(mut w serializer.Writer) {
	w.write_string(p.structure_name)
	if p.has_nbt {
		w.bool(true)
		w.write_nbt_compound_root(p.structure_nbt)
	} else {
		w.bool(false)
	}
	p.response_type.encode(mut w)
}

pub fn (mut p StructureDataResponsePacket) decode_payload(mut r serializer.Reader) ! {
	p.structure_name = r.read_string()!
	p.has_nbt = r.bool()!
	if p.has_nbt {
		p.structure_nbt = r.read_nbt_compound_root()!
	}
	p.response_type = enums.StructureTemplateResponseType.decode(mut r)!
}
