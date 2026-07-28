module types

import protocol.serializer

pub struct SerializedSkin {
pub mut:
	skin_id             string
	skin_resource_patch string
	skin_data           ImageData
	animations          []AnimationData
	cape_data           ImageData
	geometry_data       string
	animation_data      string
	premium             bool
	persona             bool
	cape_on_classic     bool
	cape_id             string
	full_skin_id        string
}

pub fn (t SerializedSkin) encode(mut w serializer.Writer) {
	w.write_string(t.skin_id)
	w.write_string(t.skin_resource_patch)
	t.skin_data.encode(mut w)
	w.le_i32(i32(t.animations.len))
	for animation in t.animations {
		animation.encode(mut w)
	}
	t.cape_data.encode(mut w)
	w.write_string(t.geometry_data)
	w.write_string(t.animation_data)
	w.bool(t.premium)
	w.bool(t.persona)
	w.bool(t.cape_on_classic)
	w.write_string(t.cape_id)
	w.write_string(t.full_skin_id)
}

pub fn SerializedSkin.decode(mut r serializer.Reader) !SerializedSkin {
	mut t := SerializedSkin{}
	t.skin_id = r.read_string()!
	t.skin_resource_patch = r.read_string()!
	t.skin_data = ImageData.decode(mut r)!
	animation_count := int(r.le_i32()!)
	t.animations = []AnimationData{cap: animation_count}
	for _ in 0 .. animation_count {
		t.animations << AnimationData.decode(mut r)!
	}
	t.cape_data = ImageData.decode(mut r)!
	t.geometry_data = r.read_string()!
	t.animation_data = r.read_string()!
	t.premium = r.bool()!
	t.persona = r.bool()!
	t.cape_on_classic = r.bool()!
	t.cape_id = r.read_string()!
	t.full_skin_id = r.read_string()!
	return t
}
