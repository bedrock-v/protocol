module packets

import serializer
import version.v582.types

pub struct TrimDataPacket {
pub mut:
	patterns  []types.TrimPattern
	materials []types.TrimMaterial
}

pub fn (p &TrimDataPacket) pid() u16 {
	return 302
}

pub fn (p &TrimDataPacket) name() string {
	return 'TrimDataPacket'
}

pub fn (p &TrimDataPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (p &TrimDataPacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint32(u32(p.patterns.len))
	for pattern in p.patterns {
		pattern.encode(mut w)
	}
	w.write_varuint32(u32(p.materials.len))
	for material in p.materials {
		material.encode(mut w)
	}
}

pub fn (mut p TrimDataPacket) decode_payload(mut r serializer.Reader) ! {
	pattern_count := int(r.read_varuint32()!)
	p.patterns = []types.TrimPattern{cap: pattern_count}
	for _ in 0 .. pattern_count {
		p.patterns << types.TrimPattern.decode(mut r)!
	}
	material_count := int(r.read_varuint32()!)
	p.materials = []types.TrimMaterial{cap: material_count}
	for _ in 0 .. material_count {
		p.materials << types.TrimMaterial.decode(mut r)!
	}
}
