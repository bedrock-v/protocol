module packets

import bedrock_v.nbt
import protocol.serializer

pub struct AddVolumeEntityPacket {
pub mut:
	id   u32
	data nbt.RootTag
}

pub fn (p &AddVolumeEntityPacket) pid() u16 {
	return 166
}

pub fn (p &AddVolumeEntityPacket) name() string {
	return 'AddVolumeEntityPacket'
}

pub fn (p &AddVolumeEntityPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &AddVolumeEntityPacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint32(p.id)
	w.write_nbt_compound_root(p.data)
}

pub fn (mut p AddVolumeEntityPacket) decode_payload(mut r serializer.Reader) ! {
	p.id = r.read_varuint32()!
	p.data = r.read_nbt_compound_root()!
}
