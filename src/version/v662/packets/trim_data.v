module packets

import protocol.serializer

pub struct TrimPattern {
pub mut:
	item_name  string
	pattern_id string
}

pub fn (e TrimPattern) encode(mut w serializer.Writer) {
	w.write_string(e.item_name)
	w.write_string(e.pattern_id)
}

pub fn TrimPattern.decode(mut r serializer.Reader) !TrimPattern {
	return TrimPattern{
		item_name:  r.read_string()!
		pattern_id: r.read_string()!
	}
}

pub struct TrimMaterial {
pub mut:
	material_id string
	color       string
	item_name   string
}

pub fn (e TrimMaterial) encode(mut w serializer.Writer) {
	w.write_string(e.material_id)
	w.write_string(e.color)
	w.write_string(e.item_name)
}

pub fn TrimMaterial.decode(mut r serializer.Reader) !TrimMaterial {
	return TrimMaterial{
		material_id: r.read_string()!
		color:       r.read_string()!
		item_name:   r.read_string()!
	}
}

pub struct TrimDataPacket {
pub mut:
	trim_pattern_list  []TrimPattern
	trim_material_list []TrimMaterial
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
	w.write_varuint32(u32(p.trim_pattern_list.len))
	for e in p.trim_pattern_list {
		e.encode(mut w)
	}
	w.write_varuint32(u32(p.trim_material_list.len))
	for e in p.trim_material_list {
		e.encode(mut w)
	}
}

pub fn (mut p TrimDataPacket) decode_payload(mut r serializer.Reader) ! {
	pat_count := int(r.read_varuint32()!)
	p.trim_pattern_list = []TrimPattern{cap: pat_count}
	for _ in 0 .. pat_count {
		p.trim_pattern_list << TrimPattern.decode(mut r)!
	}
	mat_count := int(r.read_varuint32()!)
	p.trim_material_list = []TrimMaterial{cap: mat_count}
	for _ in 0 .. mat_count {
		p.trim_material_list << TrimMaterial.decode(mut r)!
	}
}
