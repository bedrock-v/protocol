module types

import serializer

pub struct TrimPattern {
pub mut:
	item_name  string
	pattern_id string
}

pub fn (t TrimPattern) encode(mut w serializer.Writer) {
	w.write_string(t.item_name)
	w.write_string(t.pattern_id)
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

pub fn (t TrimMaterial) encode(mut w serializer.Writer) {
	w.write_string(t.material_id)
	w.write_string(t.color)
	w.write_string(t.item_name)
}

pub fn TrimMaterial.decode(mut r serializer.Reader) !TrimMaterial {
	return TrimMaterial{
		material_id: r.read_string()!
		color:       r.read_string()!
		item_name:   r.read_string()!
	}
}
