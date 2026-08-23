module packets

import protocol.serializer

pub struct FeatureDefinition {
pub mut:
	name string
	json string
}

pub fn (t FeatureDefinition) encode(mut w serializer.Writer) {
	w.write_string(t.name)
	w.write_string(t.json)
}

pub fn FeatureDefinition.decode(mut r serializer.Reader) !FeatureDefinition {
	return FeatureDefinition{
		name: r.read_string()!
		json: r.read_string()!
	}
}

pub struct FeatureRegistryPacket {
pub mut:
	features []FeatureDefinition
}

pub fn (p &FeatureRegistryPacket) pid() u16 {
	return 191
}

pub fn (p &FeatureRegistryPacket) name() string {
	return 'FeatureRegistryPacket'
}

pub fn (p &FeatureRegistryPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &FeatureRegistryPacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint32(u32(p.features.len))
	for feature in p.features {
		feature.encode(mut w)
	}
}

pub fn (mut p FeatureRegistryPacket) decode_payload(mut r serializer.Reader) ! {
	feature_count := r.read_count()!
	p.features = []FeatureDefinition{cap: serializer.prealloc(feature_count)}
	for _ in 0 .. feature_count {
		p.features << FeatureDefinition.decode(mut r)!
	}
}
