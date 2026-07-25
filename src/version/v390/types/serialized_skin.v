module types

import serializer
import version.v388.types as types_388

pub struct PersonaPieceData {
pub mut:
	piece_id   string
	piece_type string
	pack_id    string
	default    bool
	product_id string
}

pub fn (t PersonaPieceData) encode(mut w serializer.Writer) {
	w.write_string(t.piece_id)
	w.write_string(t.piece_type)
	w.write_string(t.pack_id)
	w.bool(t.default)
	w.write_string(t.product_id)
}

pub fn PersonaPieceData.decode(mut r serializer.Reader) !PersonaPieceData {
	return PersonaPieceData{
		piece_id:   r.read_string()!
		piece_type: r.read_string()!
		pack_id:    r.read_string()!
		default:    r.bool()!
		product_id: r.read_string()!
	}
}

pub struct PersonaPieceTintData {
pub mut:
	piece_type string
	colors     []string
}

pub fn (t PersonaPieceTintData) encode(mut w serializer.Writer) {
	w.write_string(t.piece_type)
	w.le_i32(i32(t.colors.len))
	for color in t.colors {
		w.write_string(color)
	}
}

pub fn PersonaPieceTintData.decode(mut r serializer.Reader) !PersonaPieceTintData {
	mut t := PersonaPieceTintData{}
	t.piece_type = r.read_string()!
	color_count := int(r.le_i32()!)
	t.colors = []string{cap: color_count}
	for _ in 0 .. color_count {
		t.colors << r.read_string()!
	}
	return t
}

pub struct SerializedSkin {
pub mut:
	skin_id             string
	skin_resource_patch string
	skin_data           types_388.ImageData
	animations          []types_388.AnimationData
	cape_data           types_388.ImageData
	geometry_data       string
	animation_data      string
	premium             bool
	persona             bool
	cape_on_classic     bool
	cape_id             string
	full_skin_id        string
	arm_size            string
	skin_color          string
	persona_pieces      []PersonaPieceData
	tint_colors         []PersonaPieceTintData
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
	w.write_string(t.arm_size)
	w.write_string(t.skin_color)
	w.le_i32(i32(t.persona_pieces.len))
	for piece in t.persona_pieces {
		piece.encode(mut w)
	}
	w.le_i32(i32(t.tint_colors.len))
	for tint in t.tint_colors {
		tint.encode(mut w)
	}
}

pub fn SerializedSkin.decode(mut r serializer.Reader) !SerializedSkin {
	mut t := SerializedSkin{}
	t.skin_id = r.read_string()!
	t.skin_resource_patch = r.read_string()!
	t.skin_data = types_388.ImageData.decode(mut r)!
	animation_count := int(r.le_i32()!)
	t.animations = []types_388.AnimationData{cap: animation_count}
	for _ in 0 .. animation_count {
		t.animations << types_388.AnimationData.decode(mut r)!
	}
	t.cape_data = types_388.ImageData.decode(mut r)!
	t.geometry_data = r.read_string()!
	t.animation_data = r.read_string()!
	t.premium = r.bool()!
	t.persona = r.bool()!
	t.cape_on_classic = r.bool()!
	t.cape_id = r.read_string()!
	t.full_skin_id = r.read_string()!
	t.arm_size = r.read_string()!
	t.skin_color = r.read_string()!
	piece_count := int(r.le_i32()!)
	t.persona_pieces = []PersonaPieceData{cap: piece_count}
	for _ in 0 .. piece_count {
		t.persona_pieces << PersonaPieceData.decode(mut r)!
	}
	tint_count := int(r.le_i32()!)
	t.tint_colors = []PersonaPieceTintData{cap: tint_count}
	for _ in 0 .. tint_count {
		t.tint_colors << PersonaPieceTintData.decode(mut r)!
	}
	return t
}
