module protocol

import serializer

pub struct CurrentStructureFeaturePacket {
pub mut:
	current_structure_feature string
}

pub fn (p &CurrentStructureFeaturePacket) pid() u16 {
	return current_structure_feature_packet
}

pub fn (p &CurrentStructureFeaturePacket) name() string {
	return 'CurrentStructureFeaturePacket'
}

pub fn (p &CurrentStructureFeaturePacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p CurrentStructureFeaturePacket) decode_payload(mut r serializer.Reader) ! {
	p.current_structure_feature = r.read_string()!
}

pub fn (p &CurrentStructureFeaturePacket) encode_payload(mut w serializer.Writer) {
	w.write_string(p.current_structure_feature)
}
