module src

import src.serializer

pub struct TrimPattern {
pub mut:
	item_id    string
	pattern_id string
}

pub struct TrimMaterial {
pub mut:
	material_id string
	color       string
	item_id     string
}

pub struct TrimDataPacket {
pub mut:
	patterns  []TrimPattern
	materials []TrimMaterial
}

pub fn (p &TrimDataPacket) pid() u16 {
	return trim_data_packet
}

pub fn (p &TrimDataPacket) name() string {
	return 'TrimDataPacket'
}

pub fn (p &TrimDataPacket) can_be_sent_before_login() bool {
	return false
}

pub fn (mut p TrimDataPacket) decode_payload(mut r serializer.Reader) ! {
	pattern_count := r.read_varuint32()!
	p.patterns = []TrimPattern{}
	for _ in 0 .. pattern_count {
		p.patterns << TrimPattern{
			item_id:    r.read_string()!
			pattern_id: r.read_string()!
		}
	}
	material_count := r.read_varuint32()!
	p.materials = []TrimMaterial{}
	for _ in 0 .. material_count {
		p.materials << TrimMaterial{
			material_id: r.read_string()!
			color:       r.read_string()!
			item_id:     r.read_string()!
		}
	}
}

pub fn (p &TrimDataPacket) encode_payload(mut w serializer.Writer) {
	w.write_varuint32(u32(p.patterns.len))
	for pat in p.patterns {
		w.write_string(pat.item_id)
		w.write_string(pat.pattern_id)
	}
	w.write_varuint32(u32(p.materials.len))
	for m in p.materials {
		w.write_string(m.material_id)
		w.write_string(m.color)
		w.write_string(m.item_id)
	}
}
