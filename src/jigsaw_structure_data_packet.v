module src

import src.serializer
import nbt

pub struct JigsawStructureDataPacket {
pub mut:
	nbt nbt.RootTag
}

pub fn (p &JigsawStructureDataPacket) pid() u16 {
	return jigsaw_structure_data_packet
}

pub fn (p &JigsawStructureDataPacket) name() string {
	return 'JigsawStructureDataPacket'
}

pub fn (p &JigsawStructureDataPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p JigsawStructureDataPacket) decode_payload(mut r serializer.Reader) ! {
	p.nbt = r.read_nbt_compound_root()!
}

pub fn (p &JigsawStructureDataPacket) encode_payload(mut w serializer.Writer) {
	w.write_nbt_compound_root(p.nbt)
}
