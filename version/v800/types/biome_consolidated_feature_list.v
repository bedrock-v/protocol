module types

import protocol.serializer

pub struct BiomeConsolidatedFeatureData {
pub mut:
	scatter      BiomeScatterParamData
	feature      u16
	identifier   u16
	pass         u16
	internal_use bool
}

pub fn (t BiomeConsolidatedFeatureData) encode(mut w serializer.Writer) {
	t.scatter.encode(mut w)
	w.le_u16(t.feature)
	w.le_u16(t.identifier)
	w.le_u16(t.pass)
	w.bool(t.internal_use)
}

pub fn BiomeConsolidatedFeatureData.decode(mut r serializer.Reader) !BiomeConsolidatedFeatureData {
	return BiomeConsolidatedFeatureData{
		scatter:      BiomeScatterParamData.decode(mut r)!
		feature:      r.le_u16()!
		identifier:   r.le_u16()!
		pass:         r.le_u16()!
		internal_use: r.bool()!
	}
}

pub struct BiomeConsolidatedFeatureList {
pub mut:
	entries []BiomeConsolidatedFeatureData
}

pub fn (t BiomeConsolidatedFeatureList) encode(mut w serializer.Writer) {
	w.write_varuint32(u32(t.entries.len))
	for e in t.entries {
		e.encode(mut w)
	}
}

pub fn BiomeConsolidatedFeatureList.decode(mut r serializer.Reader) !BiomeConsolidatedFeatureList {
	count := r.read_count()!
	mut items := []BiomeConsolidatedFeatureData{cap: serializer.prealloc(count)}
	for _ in 0 .. count {
		items << BiomeConsolidatedFeatureData.decode(mut r)!
	}
	return BiomeConsolidatedFeatureList{
		entries: items
	}
}
