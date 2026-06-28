module protocol

import serializer

pub struct FeatureRegistryEntry {
pub mut:
	name string
	json string
}

pub struct FeatureRegistryPacket {
pub mut:
	entries []FeatureRegistryEntry
}

pub fn (p &FeatureRegistryPacket) pid() u16 {
	return feature_registry_packet
}

pub fn (p &FeatureRegistryPacket) name() string {
	return 'FeatureRegistryPacket'
}

pub fn (p &FeatureRegistryPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p FeatureRegistryPacket) decode_payload(mut r serializer.Reader) ! {
	count := r.read_varuint32()!
	p.entries = []FeatureRegistryEntry{}
	for _ in 0 .. count {
		p.entries << FeatureRegistryEntry{
			name: r.read_string()!
			json: r.read_string()!
		}
	}
}

pub fn (p &FeatureRegistryPacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint32(u32(p.entries.len))
	for e in p.entries {
		w.write_string(e.name)
		w.write_string(e.json)
	}
}
