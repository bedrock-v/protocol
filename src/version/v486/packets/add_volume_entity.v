module packets

import protocol.serializer
import bedrock_v.nbt

pub struct AddVolumeEntityPacket {
pub mut:
	id             u32
	data           nbt.RootTag
	identifier     string
	instance_name  string
	engine_version string
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
	w.write_string(p.identifier)
	w.write_string(p.instance_name)
	w.write_string(p.engine_version)
}

pub fn (mut p AddVolumeEntityPacket) decode_payload(mut r serializer.Reader) ! {
	p.id = r.read_varuint32()!
	p.data = r.read_nbt_compound_root()!
	p.identifier = r.read_string()!
	p.instance_name = r.read_string()!
	p.engine_version = r.read_string()!
}
