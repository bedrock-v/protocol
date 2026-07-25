module packets

import serializer

pub struct FeaturesDataListEntry {
pub mut:
	feature_name       string
	binary_json_output string
}

pub fn (e FeaturesDataListEntry) encode(mut w serializer.Writer) {
	w.write_string(e.feature_name)
	w.write_string(e.binary_json_output)
}

pub fn FeaturesDataListEntry.decode(mut r serializer.Reader) !FeaturesDataListEntry {
	return FeaturesDataListEntry{
		feature_name:       r.read_string()!
		binary_json_output: r.read_string()!
	}
}

pub struct FeatureRegistryPacket {
pub mut:
	features_data_list []FeaturesDataListEntry
}

pub fn (p &FeatureRegistryPacket) pid() u16 { return 191 }

pub fn (p &FeatureRegistryPacket) name() string { return 'FeatureRegistryPacket' }

pub fn (p &FeatureRegistryPacket) can_be_sent_before_login() bool { return false }

pub fn (p &FeatureRegistryPacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint32(u32(p.features_data_list.len))
	for e in p.features_data_list {
		e.encode(mut w)
	}
}

pub fn (mut p FeatureRegistryPacket) decode_payload(mut r serializer.Reader) ! {
	count := int(r.read_varuint32()!)
	p.features_data_list = []FeaturesDataListEntry{cap: count}
	for _ in 0 .. count {
		p.features_data_list << FeaturesDataListEntry.decode(mut r)!
	}
}
