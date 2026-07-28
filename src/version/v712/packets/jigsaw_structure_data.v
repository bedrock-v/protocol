module packets

import protocol.serializer
import nbt

pub struct JigsawStructureDataPacket {
pub mut:
	jigsaw_structure_data_tag nbt.RootTag
}

pub fn (p &JigsawStructureDataPacket) pid() u16 {
	return 313
}

pub fn (p &JigsawStructureDataPacket) name() string {
	return 'JigsawStructureDataPacket'
}

pub fn (p &JigsawStructureDataPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &JigsawStructureDataPacket) encode_payload(mut w serializer.Writer) {
	w.write_nbt_compound_root(p.jigsaw_structure_data_tag)
}

pub fn (mut p JigsawStructureDataPacket) decode_payload(mut r serializer.Reader) ! {
	p.jigsaw_structure_data_tag = r.read_nbt_compound_root()!
}
