module types

import serializer

pub struct BiomeLegacyWorldGenRulesData {
pub mut:
	legacy_pre_hills []BiomeConditionalTransformationData
}

pub fn (t BiomeLegacyWorldGenRulesData) encode(mut w serializer.Writer) {
	w.write_varuint32(u32(t.legacy_pre_hills.len))
	for e in t.legacy_pre_hills {
		e.encode(mut w)
	}
}

pub fn BiomeLegacyWorldGenRulesData.decode(mut r serializer.Reader) !BiomeLegacyWorldGenRulesData {
	count := int(r.read_varuint32()!)
	mut items := []BiomeConditionalTransformationData{cap: count}
	for _ in 0 .. count {
		items << BiomeConditionalTransformationData.decode(mut r)!
	}
	return BiomeLegacyWorldGenRulesData{
		legacy_pre_hills: items
	}
}
